//
//  ErrorHandler.swift
//  CodableRealmTest
//
//  Created by Korchak Mykhail on 27.12.17.
//  Copyright © 2017 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire

public protocol ErrorProtocol: Swift.Error {
    associatedtype StatusCodeType: StatusCodeProtocol
    
    var statusCode: StatusCodeType { get set }
    
    static var `default`: Self { get }
    
    init()
    init(statusCode: Int)
    init(statusCode: StatusCodeType)
}

public extension ErrorProtocol {
    public init() {
        self = Self.default
    }
    
    public init(statusCode: Int) {
        guard let code = StatusCodeType.init(statusCode) else {
            self.init()
            return
        }
        self.init(statusCode: code)
    }
    
    public init(statusCode: StatusCodeType) {
        self.init()
        self.statusCode = statusCode
    }
}

/// MARK: - ErrorHandlerProtocol
/// implement this protocol for your custom error parser

public protocol ErrorHandlerProtocol {
    
    associatedtype ErrorType: ErrorProtocol
    
    static func handleError<T>(statusCode: Int, response: DataResponse<T>) -> ErrorType
    
    static func handleError(_ error: Swift.Error) -> ErrorType
}

extension ErrorHandlerProtocol {
    public static func handleError(_ error: Swift.Error) -> ErrorType {
        return (error as? ErrorType) ?? ErrorType.default
    }
}
