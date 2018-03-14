//
//  Parser.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.11.17.
//  Copyright © 2017 Korchak Mykhail. All rights reserved.
//

import Foundation
import RealmSwift

public protocol ModelProtocol: Codable {
    static var ignoreParseException: Bool { get }
}

public extension ModelProtocol {
    static var ignoreParseException: Bool {
        return false
    }
    
    public func toJSON() -> [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    public func toJSONString(outputFormatting: JSONEncoder.OutputFormatting = []) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        guard let data = try? encoder.encode(self) else { return nil }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
    
    public init?(JSON: [String: Any]?) {
        do {
            guard let json = JSON else { return nil }
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch let error {
            guard !Self.ignoreParseException else {
                Log.error.log(error.localizedDescription)
                return nil
            }
            #if DEBUG
                fatalError(error.localizedDescription)
            #else
                NSLog(error.localizedDescription)
                return nil
            #endif
        }
    }
    
    public init?(JSONString: String?) {
        do {
            guard let data = JSONString?.data(using: .utf8) else { return nil }
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch let error {
            guard !Self.ignoreParseException else {
                Log.error.log(error.localizedDescription)
                return nil
            }
            #if DEBUG
                fatalError(error.localizedDescription)
            #else
                NSLog(error.localizedDescription)
                return nil
            #endif
        }
    }
}

public extension Array where Element: ModelProtocol {
    
    /// Initialize Array from a JSON String
    public init?(JSONString: String?) {
        do {
            guard let data = JSONString?.data(using: .utf8) else { return nil }
            let objects = try JSONDecoder().decode([Element].self, from: data)
            self = objects
        } catch let error {
            guard !Element.ignoreParseException else {
                Log.error.log(error.localizedDescription)
                return nil
            }
            #if DEBUG
                fatalError(error.localizedDescription)
            #else
                NSLog(error.localizedDescription)
                return nil
            #endif
        }
    }
    
    // Need testing
    public init?(JSONArray: [[String: Any]]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: JSONArray, options: [])
            let objects: [Element] = try JSONDecoder().decode([Element].self, from: data)
            self = objects
        } catch let error {
            guard !Element.ignoreParseException else {
                Log.error.log(error.localizedDescription)
                return nil
            }
            #if DEBUG
                fatalError(error.localizedDescription)
            #else
                NSLog(error.localizedDescription)
                return nil
            #endif
        }
    }
    
    /// Returns the JSON Array
    public func toJSON() -> [[String: Any]]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [[String: Any]] }
    }
    
    /// Returns the JSON String for the object
    public func toJSONString(outputFormatting: JSONEncoder.OutputFormatting = []) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        guard let data = try? encoder.encode(self) else { return nil }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
}

fileprivate extension Data {
    func decode<T: ModelProtocol> () -> T? {
        let decoder = JSONDecoder()
        let object = try? decoder.decode(T.self, from: self)
        return object
    }
}


fileprivate extension Dictionary {
    func decode<T: ModelProtocol> () -> T? {
        let data = try? JSONSerialization.data(withJSONObject: self,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let d = data else {
            return nil
        }
        return d.decode()
    }
}

fileprivate func assertTypeIsEncodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Encodable.Type else {
        if T.self == Encodable.self || T.self == ModelProtocol.self {
            preconditionFailure("\(wrappingType) does not conform to Encodable because Encodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Encodable because \(T.self) does not conform to Encodable.")
        }
    }
}

fileprivate func assertTypeIsDecodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Decodable.Type else {
        if T.self == Decodable.self || T.self == ModelProtocol.self {
            preconditionFailure("\(wrappingType) does not conform to Decodable because Decodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Decodable because \(T.self) does not conform to Decodable.")
        }
    }
}

extension Encodable {
    func __encode(to container: inout SingleValueEncodingContainer) throws { try container.encode(self) }
    func __encode(to container: inout UnkeyedEncodingContainer)     throws { try container.encode(self) }
    func __encode<Key>(to container: inout KeyedEncodingContainer<Key>, forKey key: Key) throws { try container.encode(self, forKey: key) }
}

extension Decodable {
    fileprivate init(__from container: SingleValueDecodingContainer) throws { self = try container.decode(Self.self) }
    fileprivate init(__from container: inout UnkeyedDecodingContainer) throws { self = try container.decode(Self.self) }
    fileprivate init<Key>(__from container: KeyedDecodingContainer<Key>, forKey key: Key) throws { self = try container.decode(Self.self, forKey: key) }
}


extension RealmOptional: Encodable {
    public func encode(to encoder: Encoder) throws {
        assertTypeIsEncodable(Value.self, in: type(of: self))
        
        var container = encoder.singleValueContainer()
        if let v = self.value {
            try (v as! Encodable).encode(to: encoder)
        } else {
            try container.encodeNil()
        }
    }
}

extension RealmOptional: Decodable {
    public convenience init(from decoder: Decoder) throws {
        // Initialize self here so we can get type(of: self).
        self.init()
        assertTypeIsDecodable(Value.self, in: type(of: self))
        
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            let metaType = (Value.self as! Decodable.Type)
            let element = try metaType.init(from: decoder)
            self.value = (element as? Value)
        }
    }
}
extension List: Decodable {
    public convenience init(from decoder: Decoder) throws {
        // Initialize self here so we can get type(of: self).
        self.init()
        assertTypeIsDecodable(Element.self, in: type(of: self))
        
        let metaType = (Element.self as? Decodable.Type)
        
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try metaType?.init(__from: &container)
            if let element = element as? Element {
                self.append(element)
            }
        }
    }
}

extension List: Encodable {
    public func encode(to encoder: Encoder) throws {
        assertTypeIsEncodable(Element.self, in: type(of: self))
        
        var container = encoder.unkeyedContainer()
        for element in self {
            // superEncoder appends an empty element and wraps an Encoder around it.
            // This is normally appropriate for encoding super, but this is really what we want to do.
            let subencoder = container.superEncoder()
            try (element as! Encodable).encode(to: subencoder)
        }
    }
}
