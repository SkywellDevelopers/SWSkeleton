//
//  LoaderViewProtocol.swift
//  CodableRealmTest
//
//  Created by Misha Korchak on 16.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public typealias LoadingViewType = LoadingViewProtocol & UIView

public protocol LoadingViewProtocol {
    var hidesWhenStopped: Bool { get set }
    var isAnimating: Bool { get }
    func startAnimating()
    func stopAnimating()
}

public extension LoadingViewProtocol where Self: UIView {
    func subscribe<T: RequestStatusProtocol>(on requestStatus: Observable<T>) -> Disposable {
        return requestStatus
            .flatMap({ Observable.just($0.isLoading) })
            .bind(to: self.rx.isAnimating)
    }
}

extension UIActivityIndicatorView: LoadingViewProtocol {}

public extension Reactive where Base: LoadingViewType {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { activityIndicator, active in
            active ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}

