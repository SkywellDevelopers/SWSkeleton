//
//  RealmExtensions.swift
//  SWSkeleton
//
//  Created by Anton Komin on 5/15/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    func safeWrite(_ writing: @escaping () -> Void) throws {
        if self.isInWriteTransaction { writing() }
        else { try self.write(writing) }
    }
}
