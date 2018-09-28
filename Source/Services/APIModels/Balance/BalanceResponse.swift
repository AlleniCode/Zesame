//
//  BalanceResponse.swift
//  ZilliqaSDK
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct BalanceResponse: Decodable {
    public let balance: Double
    public let nonce: Int
}
