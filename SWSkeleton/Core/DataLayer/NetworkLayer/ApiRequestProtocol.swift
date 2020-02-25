//
//  ApiRequestProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 09.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire

public protocol ApiRequestProtocol {
    var sessionManager: SessionManager { get }
    var HTTPMethod: HTTPMethod { get }
    var parameters: Parameters { get }
    var modelToSend: ModelProtocol? { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var url: String { get }
    var logRequestDescription: Bool { get }
    var logResponseDescription: Bool { get }
    var dataRequest: DataRequest { get }
    var needsValidation: Bool { get }
    var validStatusCodeRanges: [Int] { get }
}

public extension ApiRequestProtocol {
    var sessionManager: SessionManager {
        return .skeleton
    }
    var HTTPMethod: HTTPMethod {
        return .get
    }
    var parameters: Parameters {
        return self.modelToSend?.toJSON() ?? [:]
    }
    var modelToSend: ModelProtocol? {
        return nil
    }
    var headers: HTTPHeaders {
        return [:]
    }
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var dataRequest: DataRequest {
        let request = self.sessionManager.request(self.url,
                                                  method: self.HTTPMethod,
                                                  parameters: self.parameters,
                                                  encoding: self.encoding,
                                                  headers: self.headers)
        return request
    }
    
    var needsValidation: Bool {
        return true
    }
    
    var validStatusCodeRanges: [Int] {
        return DataManager.shared.validStatusCodeRanges
    }
    
    var logRequestDescription: Bool {
        return true
    }
    
    var logResponseDescription: Bool {
        return true
    }
    
    func logDescription() {
        guard self.logRequestDescription else { return }
        Log.verbose.log("-------")
        Log.verbose.log("Request \(self.url)")
        Log.verbose.log("Parameters:", parameters: self.parameters)
        Log.verbose.log("Method \(self.HTTPMethod)")
        Log.verbose.log("Headers:", parameters: self.headers)
        Log.verbose.log("-------")
    }
}
