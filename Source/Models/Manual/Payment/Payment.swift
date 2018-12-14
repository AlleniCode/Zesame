//
//  Payment.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation




public struct Payment {
    public let recipient: Address
    public let amount: Amount
    public let gasLimit: Amount
    public let gasPrice: GasPrice
    public let nonce: Nonce

    public init(
        to recipient: Address,
        amount: Amount,
        gasLimit: Amount,
        gasPrice: GasPrice,
        nonce: Nonce = 0
        ) {
        self.recipient = recipient
        self.amount = amount
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.nonce = nonce.increasedByOne()
    }
}
