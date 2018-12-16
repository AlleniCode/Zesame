//
//  SignedTransaction.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct SignedTransaction {

    private let signature: String
    private let transaction: Transaction
    private let publicKeyCompressed: String

    init(transaction: Transaction, signedBy publicKey: PublicKey, signature: Signature) {
        self.transaction = transaction
        self.publicKeyCompressed = publicKey.hex.compressed
        self.signature = signature.asHexString()
    }
}

extension SignedTransaction: Encodable {

    enum CodingKeys: String, CodingKey {
        case version, toAddr, nonce, pubKey, amount, gasPrice, gasLimit, code, data, signature
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let tx = transaction
        let p = tx.payment

        try container.encode(tx.version, forKey: .version)
        try container.encode(p.nonce.nonce, forKey: .nonce)
        try container.encode(p.recipient, forKey: .toAddr)
        try container.encode(publicKeyCompressed, forKey: .pubKey)

        try zip(
            [p.amount.encodableValue, p.gasPrice.encodableValue, p.gasLimit.encodableValue],
            [CodingKeys.amount, CodingKeys.gasPrice, CodingKeys.gasLimit]
        ).forEach {
            try container.encode($0, forKey: $1)
        }

        try container.encode(tx.code, forKey: .code)
        try container.encode(tx.data, forKey: .data)
        try container.encode(signature, forKey: .signature)
    }
}

extension ExpressibleByAmount {
    var encodableValue: String {
        // The API expects the significand, i.e `GasPrice` is measured in 10^-12, so `150` gasPrice should be sent to API as
        // the string representation of the integer (must be integer!) representation of `150`, and not the value transalted
        // into Amount (which would be 1.5E-10).
        // The requested `Amount` of a payment is measured as is, in 10^0, i.e. a factor of 1, also as strings of integers.
        return Int(significand).description
    }
}
