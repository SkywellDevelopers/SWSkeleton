//
//  GetProductsRequest.swift
//  CodableRealmTest
//
//  Created by Korchak Mykhail on 22.12.17.
//  Copyright © 2017 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire

struct GetProductsRequest: ApiRequestProtocol {
    
    var url: String {
        return "http://13.81.15.242/apitest/products"
    }
    
    var HTTPMethod: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders {
        return ["Accept-Language" : "en-GB"]
    }
    
    var parameters: Parameters {
        return ["versionProducts" : []]
    }
}
