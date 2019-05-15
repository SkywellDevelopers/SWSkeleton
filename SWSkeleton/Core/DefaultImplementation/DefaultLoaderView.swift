//
//  DefaultLoaderView.swift
//  CodableRealmTest
//
//  Created by Misha Korchak on 16.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

public class DefaultLoaderView: UIView {
    
    // MARK: - RegisterViewProtocol
    
    public var view: UIView! {
        didSet {
            self.configure()
            self.configureColors()
        }
    }
    
    // MARK: - Public properties
    
    public var style: UIActivityIndicatorView.Style {
        get {
            return self.activityIndicator.style
        }
        set {
            self.activityIndicator.style = newValue
        }
    }
    
    public var color: UIColor? {
        get {
            return self.activityIndicator.color
        }
        set {
            self.activityIndicator.color = newValue
        }
    }
    
    // MARK: - Private properties
    
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Initializers
    
    convenience init() {
        var frame: CGRect = .zero
        frame.origin.x = UIScreen.main.bounds.width/2 - 50
        frame.origin.y = UIScreen.main.bounds.height/2 - 50
        frame.size.width = 100
        frame.size.height = 100
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ({ self.view = self.xibSetupView() })()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ({ self.view = self.xibSetupView() })()
    }
}

extension DefaultLoaderView: RegisterViewProtocol {
    public func configure() {
        self.activityIndicator.style = .whiteLarge
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        self.isUserInteractionEnabled = false
    }
    
    public func configureColors() {
        self.color = .gray
        self.view.backgroundColor = .clear
    }
}

extension DefaultLoaderView: LoadingViewProtocol {
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
        guard self.hidesWhenStopped else { return }
        self.alpha = 0
    }
}
