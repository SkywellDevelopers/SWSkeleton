//
//  UIViewControllerExtensions.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 25.02.2020.
//  Copyright © 2020 Korchak Mykhail. All rights reserved.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear)).map { _ in }
    }
    var viewDidDisappear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear)).map { _ in }
    }
    var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in }
    }
    var viewWillDisappear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear)).map { _ in }
    }
    var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews)).map { _ in }
    }
}
