//
//  RealmBaseConfigurator.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

class RealmBaseConfigurator {
    //SET new value
    static let dbVersion: UInt64 = 1
    
    static func configure() {

        var config = Realm.Configuration (
            schemaVersion: dbVersion,
//            migrationBlock: { migration, oldSchemaVersion in
//                
//        },
            deleteRealmIfMigrationNeeded:true)
        
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("example.realm")
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        Log.debug.log("REALM PATH")
        Log.debug.log(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        Log.debug.log("-----")
        // force change
        _ = try? Realm()        
    }
}
