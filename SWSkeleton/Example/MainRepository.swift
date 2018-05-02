//
//  MainRepository.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import RxSwift

protocol SWRepositoryProtocol: BaseRepositoryProtocol where RemoteStorageType == RemoteStorageProtocol, LocalStorageType == LocalStorageProtocol {}

struct MainRepository: SWRepositoryProtocol {
    static var remoteStorage: RemoteStorageProtocol = RemoteStorage()
    static var localStorage: LocalStorageProtocol = LocalStorage()
    
    static func getProducts(success: @escaping ([ProductModel]) -> Void,
                            failure: @escaping (SWError) -> Void) {
        self.remoteStorage.loadProducts(success: { (product) in
            self.localStorage.removeProducts()
            self.localStorage.saveProducts(product?.products ?? [])
            self.localStorage.fetchProducts(success: success, failure: failure)
        }, failure: failure)
    }
    
    static func getProducts() -> Observable<[ProductModel]> {
        return self.remoteStorage.loadProducts()
            .flatMap({ (products) -> Observable<[ProductModel]> in
//                self.localStorage.removeProducts()
                self.localStorage.saveProducts(products?.products ?? [])
                return self.localStorage.fetchProducts()
            })
    }
    
    static func getProduct() {
        self.remoteStorage.loadProducts(success: { (products) in
            let p = products?.products ?? []
            self.localStorage.removeProducts()
            self.localStorage.saveProducts(p)
        }, failure: {_ in})
    }
    
    static func updateProducts() {
        self.remoteStorage.loadProducts(success: { (products) in
            var p = products?.products ?? []
            p.removeLast()
            self.localStorage.removeProducts()
            self.localStorage.saveProducts(p)
        }, failure: {_ in})
    }
    
    static func fetchProducts() -> Observable<[ProductModel]> {
        return self.localStorage.fetchProducts()
//        return self.localStorage.fetchProductsWithChanges()
    }
    
    static func fetchProductsWithChanges() -> Observable<RealmCollectionChanges<[ProductModel]>> {
        return self.localStorage.fetchProductsWithChanges()
    }
}
