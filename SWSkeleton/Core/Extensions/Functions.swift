//
//  Functions.swift
//  SWSkeleton
//
//  Created by Misha Korchak on 18.06.2018.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public func sideEffect<Value>(_ action: @escaping (Value) -> ()) -> (Value) -> Value {
    return {
        action($0)
        
        return $0
    }
}

public func call<Value>(_ action: () -> Value) -> Value {
    return action()
}

