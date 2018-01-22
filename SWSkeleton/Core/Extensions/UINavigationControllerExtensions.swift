//
//  UINavigationControllerExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

public extension UINavigationController {
    public var previousViewController: UIViewController? {
        let count = self.viewControllers.count
        if count >= 2 {
            return self.viewControllers[count - 2]
        }
        return nil
    }
    
    public func previousController<T: UIViewController>() -> T? {
        let count = self.viewControllers.count
        if count >= 2, let vc = self.viewControllers[count - 2] as? T {
            return vc
        }
        return nil
    }
    
    public func removeFirstControllerFromStack<T: UIViewController>(_ vc: T.Type) {
        if let vc = self.viewControllers
            .filter({ $0 is T }).first as? T,
            let index = self.viewControllers.index(of: vc) {
            self.viewControllers.remove(at: index)
        }
    }
    
    public func removeControllersFromStackk<T: UIViewController>(_ vc: T.Type) {
        self.viewControllers = self.viewControllers.filter({ !($0 is T) })
    }
    
    public func removeControllersBetweenRootAndTop() {
        self.viewControllers = self.viewControllers.filter({
            ($0 == self.topViewController || $0 == self.viewControllers.first)
        })
    }
    
    public func getViewController<T: UIViewController>(_ vc: T.Type) -> T? {
        guard let vc = self.viewControllers.filter({ $0 is T }).first as? T else { return nil }
        return vc
    }
    
    @discardableResult
    public func popToViewController<T: UIViewController>(_ viewController: T.Type, animated: Bool) -> Bool {
        guard let vc = self.getViewController(viewController) else { return false }
        self.popToViewController(vc, animated: animated)
        return true
    }
}

