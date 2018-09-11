//
//  SendView.swift
//  ZilliqaSDKiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - SendView
final class SendView: StackViewOwningView, StackViewStyling {

    private lazy var addressLabelTitle: UILabel = "Your Public Address"
    private lazy var addressLabelValue = UILabel.Style("", height: nil, numberOfLines: 0).make()
    private lazy var balanceLabelTitle: UILabel = "Balance"
    private lazy var balanceLabelValue: UILabel = "🤷‍♀️"
    private lazy var recipientAddressField = UITextField.Style("To address", text: "74C544A11795905C2C9808F9E78D8156159D32E4").make()
    private lazy var amountToSendField = UITextField.Style("Amount", text: "15").make()
    private lazy var gasLimitField = UITextField.Style("Gas limit", text: "10").make()
    private lazy var gasPriceField = UITextField.Style("Gas price", text: "1").make()
    private lazy var sendButton: UIButton = "Send"
    private lazy var transactionIdentifierLabel: UILabel = "No tx"

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        addressLabelTitle,
        addressLabelValue,
        balanceLabelTitle,
        balanceLabelValue,
        recipientAddressField,
        amountToSendField,
        gasLimitField,
        gasPriceField,
        sendButton,
        transactionIdentifierLabel,
        .spacer
    ]
}

// MARK: - SingleContentView
extension SendView: ViewModelled {
    typealias ViewModel = SendViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            sendTrigger: sendButton.rx.tap.asDriver(),
            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasPrice: gasPriceField.rx.text.orEmpty.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.address --> addressLabelValue,
            viewModel.balance --> balanceLabelValue,
            viewModel.transactionId --> transactionIdentifierLabel
        ]
    }
}
