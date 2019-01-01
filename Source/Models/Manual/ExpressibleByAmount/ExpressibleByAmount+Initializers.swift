//
//  ExpressibleByAmount+Initializers.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation


public extension ExpressibleByAmount where Self: Upperbound, Self: Lowerbound {

    static func validate(qa: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(qa)
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(qa)
        return qa
    }
}

public extension ExpressibleByAmount where Self: Upperbound & NoLowerbound {

    static func validate(qa: Magnitude) throws -> Magnitude {
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(qa)
        return qa
    }
}

public extension ExpressibleByAmount where Self: Lowerbound, Self: NoUpperbound {

    static func validate(qa: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(qa)
        return qa
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    static func validate(qa: Magnitude) throws -> Magnitude {
        return qa
    }
}

public extension ExpressibleByAmount {
    static func validate(qa string: String) throws -> Magnitude {
        guard let qa = Magnitude(string) else {
            throw AmountError<Self>.nonNumericString
        }
        return try validate(qa: qa)
    }

}

