//
//  RepositoryProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation

public protocol BaseRepositoryProtocol {
    associatedtype RemoteStorageType
    associatedtype LocalStorageType
    
    static var remoteStorage: RemoteStorageType { get set }
    static var localStorage: LocalStorageType { get set }
}
