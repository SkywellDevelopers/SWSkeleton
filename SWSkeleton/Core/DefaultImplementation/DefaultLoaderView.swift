//
//  DefaultLoaderView.swift
//  CodableRealmTest
//
//  Created by Misha Korchak on 16.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

public class DefaultLoaderView: UIView, LoadingViewProtocol {
    
    private var activityIndicator = UIActivityIndicatorView()
    
    public var hidesWhenStopped: Bool {
        get {
            return self.activityIndicator.hidesWhenStopped
        }
        set {
            self.activityIndicator.hidesWhenStopped = newValue
        }
    }
    
    public var isAnimating: Bool {
        return self.activityIndicator.isAnimating
    }
    
    public func startAnimating() {
        self.alpha = 1
        self.activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.alpha = 0
    }
    
    convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.center
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
