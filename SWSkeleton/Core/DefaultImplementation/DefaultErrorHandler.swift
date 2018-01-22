//
//  DefaultErrorHandler.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire

/// MARK: - DefaultErrorParser

public struct SWErrorHandler: ErrorHandlerProtocol {
    public typealias ErrorType = SWError
    
    public static func handleError<T>(statusCode: Int, response: DataResponse<T>) -> SWError {
        var error: ErrorType
        guard statusCode != 0 else {
            error = SWError(statusCode: 0,
                            message: DataManager.shared.serverConnectionErrorMessage)
            return error
        }
        if let errorModel = SWErrorModel(JSON: (response.result.value as? DictionaryAlias)) {
            error = SWError(errorModel: errorModel)
        } else {
            error = SWError(statusCode: statusCode,
                            message: DataManager.shared.serverConnectionErrorMessage)
        }
        return error
    }
}

public struct SWError: ErrorProtocol {
    public static var `default`: SWError {
        return SWError(statusCode: SWStatusCode.noInternetConnection.rawValue,
                       message: SWError.defaultErrorMessage)
    }
    public typealias StatusCodeType = SWStatusCode
    
    public var statusCode: SWStatusCode
    public var message: String
    
    private static var defaultErrorMessage: String {
        return DataManager.shared.serverConnectionErrorMessage
    }
    
    init(statusCode: Int, message: String? = nil) {
        self.init(statusCode: statusCode)
        self.message = message ?? SWError.defaultErrorMessage
    }
    
    init(errorModel: SWErrorModel) {
        self.init(statusCode: errorModel.statusCode)
        self.message = errorModel.message ?? SWError.defaultErrorMessage
    }
}

public struct SWErrorModel: ModelProtocol {
    var statusCode: Int
    var message: String?
}

