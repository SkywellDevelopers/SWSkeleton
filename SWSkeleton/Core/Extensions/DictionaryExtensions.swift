//
//  DictionaryExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public extension Dictionary {
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    public mutating func update(_ other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}
