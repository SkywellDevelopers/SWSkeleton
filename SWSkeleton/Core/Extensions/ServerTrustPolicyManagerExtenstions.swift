//
//  ServerTrustPolicyManagerExtenstions.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 12/26/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Alamofire

public extension ServerTrustPolicyManager {
    static func build(forDomain domainString: String) -> ServerTrustPolicyManager {
        return ServerTrustPolicyManager(policies: [
            domainString: .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            )
        ])
    }
}
