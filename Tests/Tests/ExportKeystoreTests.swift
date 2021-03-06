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

import Foundation
import XCTest
@testable import Zesame

class ExportKeystoreTest: XCTestCase {

    func testDecodeKeystoreJson() {
        let decoded = try! JSONDecoder().decode(Keystore.self, from: keystoreWalletJson)
        XCTAssertEqual(decoded.crypto.cipherParameters.initializationVectorHex, "8c361b7b3f41109e1ec5d82fbecd8bcd")
        XCTAssertEqual(decoded.crypto.encryptedPrivateKeyHex, "80fe61275f7a4078c7fcaafeda0c108f1b79335fa320b0d4b07bcba128f0bdd5")
        XCTAssertEqual(decoded.crypto.messageAuthenticationCodeHex, "6450a59b8d4bcd27d3ea42cd40b8722cc5ddd0482645cf0e2053fdb498cfcc3b")
        XCTAssertEqual(decoded.crypto.keyDerivationFunctionParameters.saltHex, "95e3b71845b4f6410407764216c63467c7543c46792d21e14723f0ad452683d0")
    }

    func testWalletImport() {

        let expectedEncryptedPrivateKeyHex = "80fe61275f7a4078c7fcaafeda0c108f1b79335fa320b0d4b07bcba128f0bdd5"
        let password = "test_of_export_of_wallet_to_keystore_file_json_example_password"
        let service = DefaultZilliqaService(endpoint: .testnet)
        let sempaphore = expectation(description: "importing wallet from keystore json")
        let keyRestoration = try! KeyRestoration(keyStoreJSONString: keystoreWalletJSONString, encryptedBy: password)
        service.restoreWallet(from: keyRestoration) {
            switch $0 {
            case .success(let importedWallet):
                XCTAssertEqual(importedWallet.keystore.crypto.encryptedPrivateKeyHex, expectedEncryptedPrivateKeyHex)
            case .failure(let error): XCTFail("Failed to export, error: \(error)")
            }
            sempaphore.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}

private let keystoreWalletJSONString = """
{
"address": "10795a368fbc4d4dd64abf2fe534381cef1041f3",
"crypto": {
"cipher": "aes-128-ctr",
"cipherparams": {
"iv": "8c361b7b3f41109e1ec5d82fbecd8bcd"
},
"ciphertext": "80fe61275f7a4078c7fcaafeda0c108f1b79335fa320b0d4b07bcba128f0bdd5",
"kdf": "scrypt",
"kdfparams": {
"dklen": 32,
"n": 262144,
"r": 1,
"p": 8,
"salt": "95e3b71845b4f6410407764216c63467c7543c46792d21e14723f0ad452683d0"
},
"mac": "6450a59b8d4bcd27d3ea42cd40b8722cc5ddd0482645cf0e2053fdb498cfcc3b"
},
"id": "1ae9ecfb-ada3-45ff-96ff-b7c269f1b247",
"version": 3
}
"""
private let keystoreWalletJson = keystoreWalletJSONString.data(using: .utf8)!
