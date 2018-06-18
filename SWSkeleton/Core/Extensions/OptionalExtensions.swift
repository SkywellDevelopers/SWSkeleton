//
//  OptionalExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {
    @available(*, deprecated: 0.2.2, renamed: "unwrapped")
    public var value: String {
        return self.unwrapped(or: stringDummy)
    }
    
    public var unwrapped: String {
        return self.unwrapped(or: stringDummy)
    }
}

public extension Optional where Wrapped == Int {
    @available(*, deprecated: 0.2.2, renamed: "unwrapped")
    public var value: Int {
        return self.unwrapped(or: intDummy)
    }
    
    public var unwrapped: Int {
        return self.unwrapped(or: intDummy)
    }
}

public extension Optional where Wrapped == Double {
    @available(*, deprecated: 0.2.2, renamed: "unwrapped")
    public var value: Double {
        return self.unwrapped(or: doubleDummy)
    }
    
    public var unwrapped: Double {
        return self.unwrapped(or: doubleDummy)
    }
}

public extension Optional where Wrapped == Bool {
    @available(*, deprecated: 0.2.2, renamed: "unwrapped")
    public var value: Bool {
        return self.unwrapped(or: boolDummy)
    }
    
    public var unwrapped: Bool {
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
    
    public static func ??= (lhs: inout Wrapped, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }
    
    public func ifNone(_ action: @escaping () -> Void) {
        guard self == nil else { return }
        action()
    }
}

public extension Optional where Wrapped: Numeric {
    public static func ??+= (lhs: inout Wrapped, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs += rhs
        
    }
    
    public static func ??+= (lhs: inout Optional, rhs: Wrapped) {
        guard lhs != nil else { return }
        lhs! += rhs
    }
    
    public static func ??+ (lhs: Wrapped, rhs: Optional) -> Optional {
        guard let rhs = rhs else { return nil }
        return lhs + rhs
    }
    
    public static func ??+ (lhs: Optional, rhs: Wrapped) -> Optional {
        guard let lhs = lhs else { return nil }
        return lhs + rhs
    }
    
    public static func ??-= (lhs: inout Wrapped, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs -= rhs
        
    }
    
    public static func ??-= (lhs: inout Optional, rhs: Wrapped) {
        guard lhs != nil else { return }
        lhs! -= rhs
    }
    
    public static func ??- (lhs: Wrapped, rhs: Optional) -> Optional {
        guard let rhs = rhs else { return nil }
        return lhs - rhs
    }
    
    public static func ??- (lhs: Optional, rhs: Wrapped) -> Optional {
        guard let lhs = lhs else { return nil }
        return lhs - rhs
    }
}

// MARK: - Operators
infix operator ??= : AssignmentPrecedence
infix operator ??+= : AssignmentPrecedence
infix operator ??+
infix operator ??-= : AssignmentPrecedence
infix operator ??-
