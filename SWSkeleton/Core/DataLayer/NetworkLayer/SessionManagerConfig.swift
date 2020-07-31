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
    public var timeoutIntervalForResource: TimeInterval
    
    public var sessionManager: SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        let sessionManager = SessionManager(configuration: configuration,
                                            delegate: sessionDelegate,
                                            serverTrustPolicyManager: trustPolicyManager)
        sessionManager.retrier = requestRetrier
        sessionManager.adapter = requestAdapter
        sessionManager.startRequestsImmediately = startRequestsImmediately
        return sessionManager
    }
}
