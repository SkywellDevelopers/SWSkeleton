//
//  ViewModelProtocol.swift
//  SWSkeleton
//
//  Created by Krizhanovskii on 12/19/16.
//  Copyright © 2016 SkyWell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol RequestStatusProtocol {
    associatedtype Error: ErrorProtocol
    
    var isLoading: Bool { get }
    func isError(_ error: Error) -> Bool
}

public protocol ViewModelBase: UpdateProtocol {
    associatedtype ModelType
    /// Status for current request
    associatedtype RequestStatusType: RequestStatusProtocol
    /// Your model variable
    var model: ModelType { get }
    /// init functions
    init()
    /// Set new Model type
    mutating func set(_ model: ModelType)
}

public protocol BaseViewModelProtocol: ViewModelBase {
    var requestStatus: RequestStatusType { get }
    /// Closure for force view model update
    var viewModelChanged: (() -> Void)? { get set }
}

public protocol RxBaseViewModelProtocol: ViewModelBase {
    var requestStatus: Variable<RequestStatusType> { get }
}

/// Update protocol
/// Used for load and reload data from storage (remote or local)
public protocol UpdateProtocol {
    mutating func update()
    mutating func update(_ parameters: DictionaryAlias)
    mutating func update(_ page: Int)
    mutating func update<T>(_ completion: @escaping (T) -> Void)
    mutating func update<T>(_ completion: @escaping (T?) -> Void)
    mutating func update<T, E>(_ success: @escaping (T) -> Void, _ failure: @escaping (E) -> Void)
    mutating func update<T, E>(_ success: @escaping (T?) -> Void, _ failure: @escaping (E?) -> Void)
}

public extension UpdateProtocol {
    mutating func update() {}
    mutating func update(_ parameters: DictionaryAlias) {}
    mutating func update(_ page: Int) {}
    mutating func update<T>(_ completion: @escaping (T) -> Void) {}
    mutating func update<T>(_ completion: @escaping (T?) -> Void) {}
    mutating func update<T, E>(_ success: @escaping (T) -> Void, _ failure: @escaping (E) -> Void) {}
    mutating func update<T, E>(_ success: @escaping (T?) -> Void, _ failure: @escaping (E?) -> Void) {}
}

/// DataProviderProtocol
/// Used for apply data to the object
public protocol DataProviderProtocol {
    associatedtype DataType
    mutating func set(data: DataType)
}
