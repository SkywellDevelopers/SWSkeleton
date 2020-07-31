//
//  SessionManagerExtensions.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 12/26/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Alamofire

public extension SessionManager {
    func sessionManagerConfig(with trustPolicyManager: ServerTrustPolicyManager?) -> SessionManagerConfig {
        return  SessionManagerConfig(
            trustPolicyManager: trustPolicyManager,
            httpAdditionalHeaders: self.session.configuration.httpAdditionalHeaders as? HTTPHeaders,
            sessionDelegate: self.delegate,
            requestRetrier: self.retrier,
            requestAdapter: self.adapter,
            startRequestsImmediately: self.startRequestsImmediately,
            timeoutIntervalForRequest: self.session.configuration.timeoutIntervalForRequest,
            timeoutIntervalForResource: self.session.configuration.timeoutIntervalForResource
        )
    }
    
    static func getUpdatedConfigAndBuild(
        withTrustPolicyManager trustPolicyManager: ServerTrustPolicyManager?,
        _ configUpdate: @escaping (inout SessionManagerConfig) -> Void
    )
        -> (SessionManager) -> SessionManager {
            
            return { sessionManager in
                var configuration = sessionManager.sessionManagerConfig(with: trustPolicyManager)
                configUpdate(&configuration)
                return configuration.sessionManager
            }
    }
}

