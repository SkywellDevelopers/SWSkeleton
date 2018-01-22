//
//  ViewModelData.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 11.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

struct Product: ViewModelDataProtocol {
    typealias DataType = ProductModel
    
    let model: ProductModel
    
    var id: Int {
        return self.model.id
    }
    var version: Int {
        return self.model.version
    }
    var barcode: String {
        return self.model.barcode ?? ""
    }
    var name: String {
        return self.model.name ?? ""
    }
    var category: Int {
        return self.model.categoryID.value ?? 0
    }
    var image: String? {
        return self.model.image
    }
    var video: String? {
        return self.model.video
    }
    var advantage: String {
        return self.model.pAdvantage ?? ""
    }
    var use: String {
        return self.model.pUse ?? ""
    }
    var precaution: String {
        return self.model.pPrecaution ?? ""
    }
    var preservation: String {
        return self.model.pPreservation ?? ""
    }
    var ingridients: String {
        return self.model.pIngridients ?? ""
    }
    var colors: [Color] {
        return self.model.colors.map({ Color($0) })
    }
    
    init(_ model: ProductModel) {
        self.model = model
    }
    
    struct Color: ViewModelDataProtocol {
        typealias DataType = ProductColors
        
        let model: ProductColors
        
        var id: Int {
            return self.model.id
        }
        var status: Bool {
            return self.model.status
        }
        var name: String {
            return self.model.name
        }
        var filterData: String {
            return self.model.filterData ?? ""
        }
        var swatchImage: String {
            return self.model.swatchImage
        }
        var color: String {
            return self.model.color
        }
        var isDark: Bool {
            return self.model.isDark
        }
        var zone: Int {
            return self.model.zoneID
        }
        
        init(_ model: ProductColors) {
            self.model = model
        }
    }
}
