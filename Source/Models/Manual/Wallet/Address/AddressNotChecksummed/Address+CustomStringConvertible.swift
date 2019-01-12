//
//  Address+CustomStringConvertible.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension AddressNotChecksummed: CustomStringConvertible {}
public extension AddressNotChecksummed {
    var description: String {
        return hexString.description
    }
}
