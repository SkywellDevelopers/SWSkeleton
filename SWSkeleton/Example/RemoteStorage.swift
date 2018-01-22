//
//  RemoteStorage.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoteStorageProtocol {
    func loadProducts(success: @escaping (Products?) -> Void, failure: @escaping (SWError) -> Void)
    
    func loadProducts() -> Observable<Products?>
}

struct RemoteStorage: ApiClientProtocol, RemoteStorageProtocol {
    typealias ErrorHandlerType = SWErrorHandler
    
    func loadProducts(success: @escaping (Products?) -> Void, failure: @escaping (SWError) -> Void) {
        let request = GetProductsRequest()
        self.execute(request, success: success, failure: failure)
    }
    
    func loadProducts() -> Observable<Products?> {
        let request = GetProductsRequest()
        return self.rxExecute(request)
    }
}
