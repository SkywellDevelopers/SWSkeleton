//
//  ArrayExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    func nextElement(after element: Element) -> Element? {
        let index = self.firstIndex(of: element)
        return self[safe: index ??+ 1]
    }
    
    @available(*, deprecated, renamed: "previousElement(before:)")
    func prevElement(before element: Element) -> Element? {
        guard self.count != 0 else {
            return nil
        }
        
        if let index = self.firstIndex(of: element), index - 1 >= 0 {
            return self[index - 1]
        }
        
        return nil
    }
    
    func previousElement(before element: Element) -> Element? {
        let index = self.firstIndex(of: element)
        return self[safe: index ??- 1]
    }
}

public extension Array {
    func first<T>(whereTypeIs type: T.Type) -> T? {
        return self.first(where: { $0 is T }) as? T
    }
    
    func filter<T>(byType type: T.Type) -> [T] {
        return self.compactMap({ $0 as? T })
    }
    
    subscript(safe index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
    
    subscript(safe index: Index?) -> Iterator.Element? {
        guard let index = index else { return nil }
        return self[safe: index]
    }
    
    @available(*, message: "use enumerated().forEach instead", deprecated)
    func forEach(_ body: @escaping (Index, Element) throws -> Void) rethrows {
        try self.enumerated().forEach(body)
    }
}
