//
//  UIColorExtensions.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 22.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

public extension UIColor {
    public convenience init(hex: String) {
        let color = UIColor.getRGBValue(fromHex: hex)
        self.init(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
    }
    
    public typealias Color = (red: CGFloat, green: CGFloat, blue: CGFloat)
    public static func getRGBValue(fromHex hex: String) -> Color {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return (255, 255, 255)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return (red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0)
    }
}

