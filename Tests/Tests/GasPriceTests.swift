//
//  GasPriceTests.swift
//  ZilliqaSDKTests
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import ZilliqaSDK

class GasPriceTests: XCTestCase {

    func testCreatingInvalidGasPriceWithNegativeValue() {
        let price = Gas.Price(double: -1)
        XCTAssertNil(price, "Should not be possible to create price with negative value")
    }

    func testCreatingInvalidGasPriceWithZero() {
        let price = Gas.Price(double: 0)
        XCTAssertNil(price, "Should not be possible to create price with a value of zero")
    }

    func testCreatingValidGasPriceUsingDesignatedInitializer() {
        let price = Gas.Price(double: 1)
        XCTAssertTrue(price?.price == 1)
    }

    func testCreatingValidGasPriceUsingExpressibleByFloatLiteralInitializer() {
        let price: Gas.Price = 1.0
        XCTAssertTrue(price.price == 1)
    }

    func testCreatingValidGasPriceUsingExpressibleByIntegerLiteralInitializer() {
        let price: Gas.Price = 1
        XCTAssertTrue(price.price == 1)
    }
}
