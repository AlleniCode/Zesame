//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

final class SendViewModel {
    private let bag = DisposeBag()
    
    private weak var navigator: SendNavigator?
    private let service: ZilliqaServiceReactive
    private let wallet: Driver<Wallet>

    init(navigator: SendNavigator, wallet: Observable<Wallet>, service: ZilliqaServiceReactive) {
        self.navigator = navigator
        self.service = service
        self.wallet = wallet.asDriverOnErrorReturnEmpty()
    }
}

extension SendViewModel: ViewModelType {

    struct Input {
        let fetchBalanceTrigger: Driver<Void>
        let recepientAddress: Driver<String>
        let amountToSend: Driver<String>
        let gasPrice: Driver<String>
        let password: Driver<String>
        let sendTrigger: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let isSendButtonEnabled: Driver<Bool>
        let address: Driver<String>
        let nonce: Driver<String>
        let balance: Driver<String>
        let receipt: Driver<String>
    }

    func transform(input: Input) -> Output {

        let fetchBalanceSubject = BehaviorSubject<Void>(value: ())

        let fetchTrigger = Driver.merge(fetchBalanceSubject.asDriverOnErrorReturnEmpty(), input.fetchBalanceTrigger)

        let activityIndicator = ActivityIndicator()

        let balanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet) { _, w in w.address }
            .flatMapLatest {
                self.service
                    .getBalance(for: $0)
                    .trackActivity(activityIndicator)
                    .do(onNext: {
                        print("Got balance: \($0)")
                    }, onError: {
                        print("Failed to get balance, error \($0)")
                    })
                    .asDriverOnErrorReturnEmpty()
        }

        let recipient = input.recepientAddress.map { try? Address(string: $0) }

        let amount = input.amountToSend.map { try? ZilAmount(zil: $0) }

        let gasPrice = input.gasPrice.map { try? GasPrice(li: $0) }

        let payment: Driver<Payment?> = Driver.combineLatest(recipient, amount, gasPrice, balanceAndNonce) {
            guard let to = $0, let amount = $1, let price = $2, case let nonce = $3.nonce else {
                return nil
            }
            return Payment(to: to, amount: amount, gasPrice: price, nonce: nonce)
        }

        let network = service.getNetworkFromAPI().map { $0.network }

        let receipt: Driver<TransactionReceipt> = input.sendTrigger
            .withLatestFrom(Driver.combineLatest(payment.filterNil(), wallet, input.password, network.asDriverOnErrorReturnEmpty()) { (payment: $0, keystore: $1.keystore, encyptedBy: $2, network: $3) })
            .flatMapLatest {
                print("Trying to pay: \($0.payment)")
                return self.service.sendTransaction(for: $0.payment, keystore: $0.keystore, password: $0.encyptedBy, network: $0.network)
                    .do(onNext: {
                        print("Sent tx id: \($0.transactionIdentifier)")
                    }, onError: {
                        print("Failed to send transaction, error: \($0)")
                    })
                    .flatMapLatest {
                        self.service.hasNetworkReachedConsensusYetForTransactionWith(id: $0.transactionIdentifier)
                    } .asDriverOnErrorReturnEmpty()
        }

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: payment.map { $0 != nil },
            address: wallet.map { $0.address.asString },
            nonce: balanceAndNonce.map { "\($0.nonce.nonce)" },
            balance: balanceAndNonce.map { "\($0.balance.zilString)" },
            receipt: receipt.map { "Tx fee: \($0.totalGasCost) zil, for tx: \($0.transactionId)" }
        )
    }
}
