//
//  RegisterViewProtocol.swift
//
//  Created by Krizhanovskii on 9/29/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for registration view from code or nib.

///EXMAPLE:
/*
class testView : UIView, RegisterViewProtocol {

    /// this required methods by protocol and UIView init
    var view: UIView! {
        didSet {
            self.configure()
            self.configureColors()
            self.configureStaticTexts()
        }
    }

    func configure() {
        // config ypur view there
    }

    /// init func
    override init(frame: CGRect) {
        super.init(frame: frame)
        // trick: closure for force didSet in view var when init
        ({ view = xibSetuView() })()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ({ view = xibSetuView() })()
    }
}
*/

public protocol RegisterViewProtocol {
    var view: UIView! { get }
    func configure() // required. Use this for main view configuration.
    func configureColors() // optional. Use this function for perform colors
    func configureStaticTexts() // optional . Use this function for perform and reload texts
    func configureRx() // optional . Use this function for rx configuration
}

public extension RegisterViewProtocol {
    func configureColors() {}
    func configureStaticTexts() {}
    func configureRx() {}
}

public extension RegisterViewProtocol where Self:UIView {
    public static var nibName: String {
        return String(describing: self)
    }

    /// Returns view from nib or create new view programaticaly
    public func xibSetupView() -> UIView {
        let nib = UINib(nibName: Self.nibName, bundle: nil)

        var view: UIView
        if Bundle.main.path(forResource: Self.nibName, ofType: "nib") == nil {
            view = UIView(frame: self.bounds)
        } else {
            view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView(frame: self.bounds)
        }

        view.frame = bounds
        view.backgroundColor = .clear

        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        return view
    }
}


/// XibProtocol. 
/// Init view from XIB by name
public protocol XibProtocol {}

public extension XibProtocol where Self: UIViewController {
    public static func initiateFromXIB() -> Self {
        return Self.init(nibName: String(describing: Self.self), bundle: Bundle.main)
    }
}
