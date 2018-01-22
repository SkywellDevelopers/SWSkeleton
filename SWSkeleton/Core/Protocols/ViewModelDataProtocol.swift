//
//  ViewModelDataProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 11.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public protocol ViewModelDataProtocol {
    associatedtype ModelType
    var model: ModelType { get }
    
    init(_ model: ModelType)
}


public protocol DataContainerProtocol {
    associatedtype DataType
    var data: DataType { get }
}
