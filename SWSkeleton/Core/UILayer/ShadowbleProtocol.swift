//
//  ShadowbleProtocol.swift
//  AuchanMobile
//
//  Created by Krizhanovskii on 11/18/16.
//  Copyright © 2016 ua.com.skywell. All rights reserved.
//

import Foundation
import UIKit

public protocol Shadowle {}
extension UIView: Shadowle {}

extension Shadowle where Self: UIView {
    public func addShadowWith(size: CGSize, color: UIColor = .gray, radius: CGFloat = 1, shadowOpacity: Double = 0.8) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
