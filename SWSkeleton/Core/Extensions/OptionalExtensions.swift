//
//  OptionalExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {
    public var value: String {
        return self.unwrapped(or: stringDummy)
    }
}

public extension Optional where Wrapped == Int {
    public var value: Int {
        return self.unwrapped(or: intDummy)
    }
}

public extension Optional where Wrapped == Double {
    public var value: Double {
        return self.unwrapped(or: doubleDummy)
    }
}

public extension Optional where Wrapped == Bool {
    public var value: Bool {
        return self.unwrapped(or: boolDummy)
    }
}

public extension Optional {
    public func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
    
    public func run(_ block: @escaping (Wrapped) -> Void) {
        _ = self.map(block)
    }

    public static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }
}

// MARK: - Operators
infix operator ??= : AssignmentPrecedence
