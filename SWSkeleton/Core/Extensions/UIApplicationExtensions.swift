//
//  UIApplicationExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

public extension UIApplication {
    public class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    public static var statusBar: UIView? {
        return UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
    
    public static var statusBarIsHidden: Bool {
        get {
            return self.statusBar?.alpha == 0 ? true : false
        }
        set {
            self.statusBar?.alpha = newValue ? 0 : 1
        }
    }
}
