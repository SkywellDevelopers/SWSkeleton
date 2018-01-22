//
//  DefaultProtocols.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

/// Request status
public enum SWRequestStatus: RequestStatusProtocol, Equatable {
    
    public typealias Error = SWError
    
    case `default`
    case loading // request now loading
    case success // request success complete
    case error(Error) // request complete with error
    
    public var isLoading: Bool {
        return self == .loading
    }
    
    public func isError(_ error: Error) -> Bool {
        switch self {
        case .error(let currentError):
            return error.statusCode == currentError.statusCode
                && error.message == currentError.message
        default:
            return false
        }
    }

    public static func ==(lhs: SWRequestStatus,
                          rhs: SWRequestStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.loading, .loading):
            return true
        case (.error(let lError), .error(let rError)):
            return lError.statusCode == rError.statusCode
                && lError.message == rError.message
        case (.default, .default):
            return true
        default:
            return false
        }
    }
}

protocol SWViewModelProtocol: BaseViewModelProtocol {}
extension SWViewModelProtocol {
    typealias RequestStatusType = SWRequestStatus
}

protocol SWRxViewModelProtocol: RxBaseViewModelProtocol {}
extension SWRxViewModelProtocol {
    typealias RequestStatusType = SWRequestStatus
}

// Status codes codes
public enum SWStatusCode: Int, StatusCodeProtocol {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    case badRequest = 400
    case badCredentials = 401
    case accessForbidden = 403
    case objectNotFound = 404
    
    case unprocessableEntity = 422
    case limitedRequest = 429
    
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    
    case noInternetConnection = -1009
    case requestTimeout = -1001
    case internetConnectionWasLost = -1005
    case serverCouldNotBeFound = -1003
}
