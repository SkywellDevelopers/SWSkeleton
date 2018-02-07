//
//  ArrayExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    public func nextElement(after element: Element) -> Element? {
        guard self.count > 0 else {
            return nil
        }
        
        if let index = self.index(of: element), index + 1 < self.count {
            return self[index + 1]
        }
        
        return nil
    }
    
    public func prevElement(before element: Element) -> Element? {
        guard self.count != 0 else {
            return nil
        }
        
        if let index = self.index(of: element), index - 1 >= 0 {
            return self[index - 1]
        }
        
        return nil
    }
}

public extension Array {
    
    public subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    public func forEach(_ body: @escaping (Index, Element) throws -> Void) rethrows {
        for index in 0 ..< self.count {
            try body(index, self[index])
        }
    }
}
