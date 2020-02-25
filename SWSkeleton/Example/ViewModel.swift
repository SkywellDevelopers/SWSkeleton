//
//  ViewModel.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel: SWViewModelProtocol, DataContainerProtocol {
    
    typealias DataType = [Product]
    
    var data: [Product] {
        return self.model.map({ Product($0) })
    }
    
    typealias ModelType = [ProductModel]
    
    var requestStatus: SWRequestStatus = {
        return .default
        }() {
        didSet {
            self.viewModelChanged?()
        }
    }
    
    var viewModelChanged: (() -> Void)?
    
    var model: ModelType
    
    init() {
        self.model = ModelType()
    }
    
    init(_ model: ModelType) {
        self.model = model
    }
    
    func set(_ model: ModelType) {
        self.model = model
    }
    
    func update() {
        self.requestStatus = .loading
        MainRepository.getProducts(success: { (products) in
            self.set(products)
            self.requestStatus = .success
        }) { (error) in
            self.requestStatus = .error(error)
        }
    }
}

final class RxViewModel: SWRxViewModelProtocol, DataContainerProtocol {
    
    typealias DataType = BehaviorRelay<[Product]>
    
    var data = DataType(value: [])
    
    typealias ModelType = [ProductModel]
    
    var requestStatus: BehaviorRelay<SWRequestStatus> = BehaviorRelay(value: .default)
    
    private let disposeBag = DisposeBag()
    private var disposable: Disposable?
    
    var model: ModelType
    
    init() {
        self.model = ModelType()
    }
    
    func set(_ model: ModelType) {
        self.model = model
        self.data.accept(self.model.map({ Product($0) }))
    }
    
    func update() {
        self.requestStatus.accept(.loading)
        MainRepository.getProducts()
            .subscribe(onNext: { [weak self] (products) in
                self?.set(products)
                self?.requestStatus.accept(.success)
            }, onError: { [weak self] (error) in
                self?.requestStatus.accept(.error(SWErrorHandler.handleError(error)))
            }, onDisposed: { [weak self] in
                self?.requestStatus.accept(.default)
                self?.data.accept([])
            }).disposed(by: self.disposeBag)
    }
}
