// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import XCTest
import EllipticCurveKit
@testable import Zesame

private let network: Network = .mainnet
private let service = DefaultZilliqaService(endpoint: .testnet)

class TransactionSigningTests: XCTestCase {

    func testTransactionSigning() {

        // Some uninteresting Zilliqa TESTNET private key, that might contain some worthless TEST tokens.
        let privateKey = PrivateKey(hex: "0E891B9DFF485000C7D1DC22ECF3A583CC50328684321D61947A86E57CF6C638")!
        let publicKey = PublicKey(privateKey: privateKey)

        let unsignedTx = Transaction(
            payment: Payment(
                to: try! Address(string: "9Ca91EB535Fb92Fda5094110FDaEB752eDb9B039"),
                amount: 15,
                gasLimit: 1,
                gasPrice: GasPrice.min,
                nonce: Nonce(3)
            ),
            version: Version(network: network)
        )

        let message = messageFromUnsignedTransaction(unsignedTx, publicKey: publicKey)
        let signature = service.sign(message: message, using: KeyPair(private: privateKey, public: publicKey))

        let signedTransaction = SignedTransaction(transaction: unsignedTx, signedBy: publicKey, signature: signature)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let transactionJSONData = try jsonEncoder.encode(signedTransaction)
            let transactionJSONString = String(data: transactionJSONData, encoding: .utf8)!
            XCTAssertEqual(transactionJSONString, expectedTransactionJSONString)
        } catch {
            return XCTFail("Should not throw, unexpected error: \(error)")
        }
    }
}

private let expectedTransactionJSONString = """
{
  "amount" : "15000000000000",
  "toAddr" : "9Ca91EB535Fb92Fda5094110FDaEB752eDb9B039",
  "pubKey" : "034AE47910D58B9BDE819C3CFFA8DE4441955508DB00AA2540DB8E6BF6E99ABC1B",
  "data" : null,
  "code" : null,
  "signature" : "1727048B9F200D07E6E2D8EFF6BA3E54BF491589CCB55D872E242505B72E6CA74E022AC954DF21420AF8737C89A7E9048B75B531F6865B78B1E2A864169ED64D",
  "gasLimit" : "1",
  "version" : 65537,
  "gasPrice" : "1000000000",
  "nonce" : 4
}
"""
