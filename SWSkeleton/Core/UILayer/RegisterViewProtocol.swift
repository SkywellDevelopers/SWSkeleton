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

public protocol RegisterViewProtocol: class {
    var view: UIView! { get set }
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

public extension RegisterViewProtocol where Self: UIView {
    public static var nibName: String {
        return String(describing: self)
    }

    /// Returns view from nib or create new view programaticaly
    public func xibSetupView() -> UIView {
        let nib = UINib(nibName: Self.nibName, bundle: Bundle(for: Self.self))
        
        var view: UIView
        if Bundle(for: Self.self).path(forResource: Self.nibName, ofType: "nib") == nil {
            view = UIView(frame: self.bounds)
        } else {
            view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView(frame: self.bounds)
        }
        
        view.frame = bounds
        view.backgroundColor = .clear
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        return view
    }
    
    public static func <- (_ container: Self, _ newView: @escaping () -> UIView) {
        call { container.view = newView() }
    }
}

infix operator <- : AssignmentPrecedence

/// XibProtocol. 
/// Init view from XIB by name
public protocol XibProtocol {}

public extension XibProtocol where Self: UIViewController {
    public static func instantiateFromXib() -> Self {
        return Self.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
}
