//
//  BaseUIKit.swift
//  CodableRealmTest
//
//  Created by Misha Korchak on 16.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as? BaseView)?.didLoad()
        self.view.subviews.forEach { (view) in
            (view as? BaseView)?.didLoad()
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (self.view as? BaseView)?.willAppear(animated)
        self.view.subviews.forEach { (view) in
            (view as? BaseView)?.willAppear(animated)
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (self.view as? BaseView)?.didAppear(animated)
        self.view.subviews.forEach { (view) in
            (view as? BaseView)?.didAppear(animated)
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.view as? BaseView)?.willDisappear(animated)
        self.view.subviews.forEach { (view) in
            (view as? BaseView)?.willDisappear(animated)
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        (self.view as? BaseView)?.didDisappear(animated)
        self.view.subviews.forEach { (view) in
            (view as? BaseView)?.didDisappear(animated)
        }
    }
}

open class BaseView: UIView {
    
    @IBInspectable
    open var containsLoadingView: Bool = false
    
    open lazy var loadingView: LoadingViewType = DataManager.shared.loaderView
    
    open func willAppear(_ animated: Bool) {}
    
    open func didAppear(_ animated: Bool) {}
    
    open func willDisappear(_ animated: Bool) {}
    
    open func didDisappear(_ animated: Bool) {}
    
    open func didLoad() {
        guard self.containsLoadingView else { return }
        self.addSubview(self.loadingView)
        self.loadingView.center = self.center
        self.loadingView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
}
