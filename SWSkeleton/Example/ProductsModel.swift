//
//  ProductsModel.swift
//  CodableRealmTest
//
//  Created by Korchak Mykhail on 22.12.17.
//  Copyright © 2017 Korchak Mykhail. All rights reserved.
//

import Foundation
import RealmSwift

struct Products: ModelProtocol {
    var products: [ProductModel]
}

class ProductModel: Object, ModelProtocol {
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var id: Int = intDummy
    @objc dynamic var version: Int = intDummy
    @objc dynamic var name: String?
    @objc dynamic var barcode: String?
    var categoryID = RealmOptional<Int>()
    @objc dynamic var image: String?
    @objc dynamic var video: String?
    
    // attributes
    @objc dynamic var pAdvantage: String?
    @objc dynamic var pUse: String?
    @objc dynamic var pPrecaution: String?
    @objc dynamic var pPreservation: String?
    @objc dynamic var pIngridients: String?
    // arrays
    var colors: List<ProductColors> = List<ProductColors>()
    private enum CodingKeys: String, CodingKey {
        case id = "idProduct"
        case version = "version"
        case name = "name"
        case barcode = "barcode"
        case categoryID = "category"
        case image = "thumbnailImage"
        case video = "video"
        
        // attributes
        case pAdvantage = "pAdvantage"
        case pUse = "pUse"
        case pPrecaution = "pPrecaution"
        case pPreservation = "pReservation"
        case pIngridients = "pIngredients"
        case colors
    }
    
    
}

class ProductColors: Object, ModelProtocol {
    @objc dynamic var id: Int = intDummy
    @objc dynamic var status: Bool = false
    @objc dynamic var name: String = stringDummy
    @objc dynamic var filterData: String?
    @objc dynamic var swatchImage: String = stringDummy
    @objc dynamic var color: String = stringDummy
    @objc dynamic var isDark: Bool = boolDummy
    @objc dynamic var zoneID: Int = intDummy
    

}
