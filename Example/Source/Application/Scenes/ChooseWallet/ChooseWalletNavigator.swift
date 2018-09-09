//
//  ChooseWalletNavigator.swift
//  ZilliqaSDKiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import ZilliqaSDK

final class ChooseWalletNavigator: Navigator {

    private weak var navigationController: UINavigationController?
    private let chosenWallet: (Wallet) -> Void

    init(navigationController: UINavigationController, chosenWallet: @escaping (Wallet) -> Void) {
        self.navigationController = navigationController
        self.chosenWallet = chosenWallet
    }

    deinit {
        print("💣 ChooseWalletNavigator")
    }
}

extension ChooseWalletNavigator {
    enum Destination {
        case chooseWallet
        case chosen(wallet: Wallet)
        case createNewWallet
        case restoreWallet
    }

    func start() {
        navigate(to: .chooseWallet)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .chosen(let wallet): chosenWallet(wallet)
        case .chooseWallet:
            navigationController?.pushViewController(
                ChooseWalletController(viewModel: ChooseWalletViewModel(navigate(to:))),
                animated: true
            )
        case .createNewWallet:
            let navigator = CreateNewWalletNavigator(navigationController: navigationController) { [weak self] in
                self?.navigate(to: .chosen(wallet: $0))
            }
            navigator.start()
        case .restoreWallet:
            let navigator = RestoreWalletNavigator(navigationController: navigationController) { [weak self] in
                self?.navigate(to: .chosen(wallet: $0))
            }
            navigator.start()
        }
    }
}
