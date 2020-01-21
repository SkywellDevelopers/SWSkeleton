//
//  SessionManagerConfig.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 12/26/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Alamofire

public struct SessionManagerConfig {
    public let trustPolicyManager: ServerTrustPolicyManager?
    public var httpAdditionalHeaders: HTTPHeaders?
    public var sessionDelegate: SessionDelegate
    public var requestRetrier: RequestRetrier?
    public var requestAdapter: RequestAdapter?
    public var startRequestsImmediately: Bool
    public var timeoutIntervalForRequest: TimeInterval
    
    public var sessionManager: SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = self.httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = self.timeoutIntervalForRequest
        let sessionManager = SessionManager(configuration: configuration,
                                            delegate: self.sessionDelegate,
                                            serverTrustPolicyManager: self.trustPolicyManager)
        sessionManager.retrier = self.requestRetrier
        sessionManager.adapter = self.requestAdapter
        sessionManager.startRequestsImmediately = self.startRequestsImmediately
        return sessionManager
    }
}
