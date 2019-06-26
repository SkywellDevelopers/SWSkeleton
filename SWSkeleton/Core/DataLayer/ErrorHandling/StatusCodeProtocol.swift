//
//  StatusCodeProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 09.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire

public protocol StatusCodeProtocol {
    var isRequestErrorCode: Bool { get }
    var isDataBaseErrorCode: Bool { get }
    
    init?(_ statusCode: Int)
}

public extension StatusCodeProtocol where Self: RawRepresentable, Self.RawValue == Int {
    var isDataBaseErrorCode: Bool {
        return self.rawValue == DataManager.shared.dataBaseErrorStatusCode
    }
    
    var isRequestErrorCode: Bool {
        return !(self.isDataBaseErrorCode && DataManager.shared.validStatusCodeRanges.contains(self.rawValue))
    }
    
    init?(_ statusCode: Int) {
        self.init(rawValue: statusCode)
    }
}
