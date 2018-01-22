//
//  PaginationProtocol.swift
//  TemplateProject
//
//  Created by Krizhanovskii on 3/3/17.
//  Copyright © 2017 skywell.com.ua. All rights reserved.
//

import Foundation

public protocol PaginationProtocol {
    var currentPage: Int { get set }
    var totalPages: Int { get set }

    func getNext()
}

