////
////  TransactionSigningTests.swift
////  Zesame
////
////  Created by Alexander Cyon on 2018-09-11.
////  Copyright © 2018 Open Zesame. All rights reserved.
////
//
//import XCTest
//import EllipticCurveKit
//@testable import Zesame
//
//// Some uninteresting Zilliqa TESTNET private key, containing worthless TEST tokens.
//private let privateKey = "0E891B9DFF485000C7D1DC22ECF3A583CC50328684321D61947A86E57CF6C638"
//private let wallet = Wallet(privateKeyHex: privateKey, nonce: 3)!
//private let service = DefaultZilliqaService(wallet: wallet)
//
//
//class TransactionSigningTests: XCTestCase {
//    func testSample() {
//        let message = Message(message: "sample")
//        let signature = service.sign(message: message, using: wallet.keyPair)
////        XCTAssertEqual(signature.asHexString(), "55ec312a2936a0fca8d95b7082d2e6dbd4dcd8fc6e6957dd805491f3d84d8b9b72f9f3dd9ab610dc7fd9453f208eb0ca1a88146fb7c8381fec81065ce2059c0b")
//
//        XCTAssertTrue(Signer.verify(message, wasSignedBy: Signature(hex: "55ec312a2936a0fca8d95b7082d2e6dbd4dcd8fc6e6957dd805491f3d84d8b9b72f9f3dd9ab610dc7fd9453f208eb0ca1a88146fb7c8381fec81065ce2059c0b")!, publicKey: wallet.keyPair.publicKey))
//    }
//
//    func testTransactionSigning() {
//
//
//
//        XCTAssertEqual(wallet.keyPair.publicKey.hex.compressed.lowercased(), "034ae47910d58b9bde819c3cffa8de4441955508db00aa2540db8e6bf6e99abc1b")
//
//
//        let recipient = Recipient(string: "9CA91EB535FB92FDA5094110FDAEB752EDB9B039")!
//
//        let payment = Payment(
//            to: recipient,
//            amount: 15,
//            gasLimit: 1,
//            gasPrice: 1,
//            from: wallet
//        )!
//
//        let unsignedTx = UnsignedTransaction(payment: payment, version: 0)
//
//
//        XCTAssertEqual(unsignedTx.amount, 15)
//        XCTAssertEqual(unsignedTx.gasLimit, 1)
//        XCTAssertEqual(unsignedTx.gasPrice, 1)
//        XCTAssertEqual(unsignedTx.nonce, 4)
//        XCTAssertEqual(unsignedTx.version, 0)
//        XCTAssertEqual(unsignedTx.to, "9CA91EB535FB92FDA5094110FDAEB752EDB9B039")
//
//
//        let message = messageFromUnsignedTransaction(unsignedTx, publicKey: wallet.keyPair.publicKey)
//
//        XCTAssertEqual(message.description, "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000049CA91EB535FB92FDA5094110FDAEB752EDB9B039034ae47910d58b9bde819c3cffa8de4441955508db00aa2540db8e6bf6e99abc1b000000000000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000")
//
//        let signature = service.sign(message: message, using: wallet.keyPair)
//
//        // Generated by createhttps://github.com/Zilliqa/Zilliqa-JavaScript-Library/commit/3a4566138def7d622b0bbc331186ce7d2b8c465c
//        let expectedSignature = "bb32937fe38faeb28968a4b346d8dbbce22228ae0399b32c29b370c65417a7724af3e392cdf251d9e51803d56c0d98ac38b4346b7151d0a59f6f31376b2e025f"
//
//        XCTAssertEqual(signature.asHexString(), expectedSignature)
//
//    }
//}
