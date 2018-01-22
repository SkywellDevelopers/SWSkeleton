//
//  LocalStorage.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

typealias RealmObservable<T: RealmCollectionValue> = Observable<AnyRealmCollection<T>>

protocol LocalStorageProtocol {
    func removeProducts()
    
    func saveProducts(_ products: [ProductModel])
    
    func fetchProducts(success: @escaping ([ProductModel]) -> Void, failure: @escaping (SWError) -> Void)
    func fetchProducts() -> Observable<[ProductModel]>
    func fetchProductsWithChanges() -> Observable<RealmCollectionChanges<[ProductModel]>>
}

struct LocalStorage: RealmClientProtocol, LocalStorageProtocol {
    typealias ErrorType = SWError
    
    func removeProducts() {
        self.removeAllDataFrom(ProductModel.self)
    }
    
    func saveProducts(_ products: [ProductModel]) {
        self.saveModelArrayToStorage(products)
    }
    
    func fetchProducts(success: @escaping ([ProductModel]) -> Void, failure: @escaping (SWError) -> Void) {
        self.fetchAllItems(ProductModel.self, success: success, failure: failure)
    }
    
    func fetchProducts() -> Observable<[ProductModel]> {
        return self.fetchAllItems()
    }
    
    func fetchProductsWithChanges() -> Observable<RealmCollectionChanges<[ProductModel]>> {
        return self.fetchAllItemsWithChanges()
    }
}
