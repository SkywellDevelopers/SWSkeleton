//
//  StoryboardProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 11.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import UIKit

/// Storyboard protocol
public protocol StoryboardProtocol {
    var storyboardName: String { get }
    var storyboard: UIStoryboard { get }
    var bundle: Bundle? { get }
}

public extension StoryboardProtocol {
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: self.bundle)
    }
    
    public var bundle: Bundle? {
        return nil
    }
    
    /// try get initial storyboard cntrl
    ///
    /// - Returns: UIVIewController type
    public func instantiateInitialViewController<T>() -> T {

        guard let cntrl = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not find contoller for \(String(describing: T.self))")
        }
        return cntrl
    }

    /// try get initial storyboard cntrl
    ///
    /// - Returns: UINavigationController type
    public func storyboardWithNavigationContoller<T: UINavigationController>() -> T {
        guard let cntrl = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not find navigationController for \(String(describing: Self.self))")
        }
        return cntrl
    }

    /// try get initial storyboard cntrl
    ///
    /// - Returns: UITabBarController type
    public func storyboardWithTabBarController<T: UITabBarController>() -> T {
        guard let tabBarController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not find tabBarController for \(String(describing: Self.self))")
        }
        tabBarController.childViewControllers.forEach({ $0.loadViewIfNeeded() })
        return tabBarController
    }

    /// try get initial storyboard cntrl
    ///
    /// - Returns: Couple of UIViewController and UINavigationController
    public func storyboardControllerInsideContainer<T: UIViewController>(_ navigation: UINavigationController.Type) -> (T, UINavigationController) {
        let vc: T = self.instantiateInitialViewController()
        let nav = navigation.init(rootViewController: vc)
        return (vc, nav)

    }
    
    /// try get cntrl with the storyboardID == ClassName
    ///
    /// - Parameter cntrl: UIViewController Type
    /// - Returns: return UIViewController type controller
    public func instantiateViewController<T: UIViewController>(_ cntrl: T.Type) -> T {
        guard let vc = self.storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not find viewController in storyboard:\(String(describing: self))for \(String(describing: T.self))")
        }
        return vc
    }
}
