//
//  RealmClientProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

public struct WeakBox<Value: AnyObject> {
    
    // MARK: -
    // MARK: Properties
    
    public var isEmpty: Bool {
        return self.value == nil
    }
    
    public private(set) weak var value: Value?
    
    // MARK: -
    // MARK: Init and Deinit
    
    public init(_ value: Value?) {
        self.value = value
    }
}

extension WeakBox: Equatable {
    public static func == (lhs: WeakBox, rhs: WeakBox) -> Bool {
        return lhs.value.flatMap { lhs in
            rhs.value.map { lhs === $0 }
            } ?? false
    }
}


public protocol RealmClientProtocol {
    associatedtype ErrorType: ErrorProtocol
    
    init()
}

fileprivate struct Key {
    static let realm = "com.realm.thread"
}

public extension RealmClientProtocol {
    
    public func write(_ action: @escaping (Realm?) -> Void) {
        if self.realm?.isInWriteTransaction == true {
            action(self.realm)
        } else {
            try? self.realm?.write { action(self.realm) }
        }
    }
    
    public func write(_ action: @escaping () -> Void) {
        if self.realm?.isInWriteTransaction == true {
            action()
        } else {
            try? self.realm?.write { action() }
        }
    }
    
//    public func realm() throws -> Realm {
//
//            let key = Key.realm
//            let thread = Thread.current
//
//        return call({ () -> Value in
//            <#code#>
//        })
//
//        return thread.threadDictionary[key]
//            .flatMap { ($0 as? WeakBox<Realm>)?.value } ?? sideEffect { (realm: Realm) in
//                thread.threadDictionary[key] = WeakBox(realm)
//            }(try Realm())
//            return thread.threadDictionary[key]
//                .flatMap { $0 as? WeakBox<Realm> }
//                .flatMap { $0.value }
//                ?? call {
//
//                    (try Realm()).flatMap(
//                        sideEffect { thread.threadDictionary[key] = WeakBox($0) }
//                    )
//            }
//
//
//    }
    
    public var realm: Realm? {
        let key = Key.realm
        let thread = Thread.current

        return thread.threadDictionary[key]
            .flatMap { $0 as? WeakBox<Realm> }
            .flatMap { $0.value }
            ?? call {
                (try? Realm()).flatMap(
                    sideEffect { thread.threadDictionary[key] = WeakBox($0) }
                )
        }
    }
    
    func update<T: Object>(_ object: T, updateAction: @escaping (T) -> Void) {
        self.write {
            updateAction(object)
        }
    }
    
    func updateValue<T: Object>(_ type: T.Type,
                                predicate: NSPredicate,
                                value: Any?,
                                forKey key: String) {
        do {
            let realm = try Realm()
            if let object = realm.objects(type).filter(predicate).first {
                try realm.write {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            Log.error.log("RealmProtocol: error \(error.localizedDescription) with saving type \(type)")
        }
    }
    
    func updateValue<T: Object>(of object: inout T,
                                value: Any?,
                                forKey key: String) {
        do {
            let realm = try Realm()
            try realm.write {
                object.setValue(value, forKey: key)
            }
        } catch {
            Log.error.log("RealmProtocol: error \(error.localizedDescription) with saving type \(T.self)")
        }
    }
    
    ///  Save Realm model with update
    ///
    ///  Parameter model: model
    /// - Parameter update: update flag
    public func saveModelToStorage<M: Object>(_ model: M, withUpdate update: Bool = true) {
        self.saveObject(model, withUpdate: update)
    }

    ///  Save Realm Array model with update
    ///
    /// - Parameter model: Array  of model
    /// - Parameter update: update flag
    public func saveModelArrayToStorage<M: Object>(_ array: Array<M>, withUpdate update: Bool = true) {
        self.write { (realm) in
            realm?.add(array, update: update)
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(array, update: update)
            }
        } catch let error {
            Log.error.log("RealmProtocol: error \(error.localizedDescription) with saving type \(M.self)")
        }
    }
    
    ///  Save or update object
    ///
    /// - Parameter model: model
    /// - Parameter update:  update flag. default is false
    public func saveObject<M: Object>(_ model: M, withUpdate update: Bool = false) {
        
        do {
            let r = try Realm()
            try r.write {
                r.add(model, update: update)
            }
        } catch {
            Log.error.log("RealmProtocol: error \(error.localizedDescription) with saving type \(M.self)")
        }
    }
    

    /// Remove all data from table
    ///
    /// - Parameter type: Object.Type
    public func removeAllDataFrom<R: Object>(_ type: R.Type) {
        let objects = self.realm?.objects(type)
        objects.run { (objects) in
            self.write({ (realm) in
                realm?.delete(objects)
            })
        }
        do {
            let items  = try Realm().objects(type.self)
            let realm = try Realm()
            try realm.write {
                realm.delete(items)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Can't delete all data")
        }
    }
    
    /// Remove sibgle object
    ///
    /// - Parameter object: Object to be removed
    public func removeObject<R: Object>(_ object: R) {
        self.write { (realm) in
            realm?.delete(object)
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot delete object \(object)")
        }
    }

    /// Fetch all items that conform NSPredicate
    ///
    /// - Parameters:
    ///   - type: Realm Object type
    ///   - predicate: NSPredicate
    ///   - success: array of model
    public func fetchItems<M: Object>(_ type: M.Type,
                                      predicate: NSPredicate,
                                      success: @escaping ([M]) -> Void,
                                      failure: @escaping (ErrorType) -> Void) {
        Log.info.log("RealmProtocol: Fetching items with predicate \(predicate)")
        do {
            success(try Realm().objects(M.self).filter(predicate).map({ $0 }))
        } catch {
            failure(ErrorType(statusCode: DataManager.shared.dataBaseErrorStatusCode))
            Log.error.log("RealmProtocol: error \(error.localizedDescription), type \(type)")
        }
    }

    /// Fetch all items
    ///
    /// - Parameters:
    ///   - type: Realm Object type
    ///   - success: array of model
    public func fetchAllItems<M: Object>(_ type: M.Type,
                                         success: @escaping ([M]) -> Void,
                                         failure: @escaping (ErrorType) -> Void) {
        do {
            success(try Realm().objects(M.self).map({ $0 }))
        } catch {
            Log.error.log("RealmProtocol: error \(error.localizedDescription), type \(M.self)")
            failure(ErrorType(statusCode: DataManager.shared.dataBaseErrorStatusCode))
        }
    }
    
    // MARK: - Rx
    
    public func fetchAllItems<M: Object>() -> Observable<[M]> {
        do {
            return try Realm().objects(M.self).asObservable()
        } catch {
            return Observable<[M]>.error(error)
        }
    }
    
    public func fetchItems<M: Object>(predicate: NSPredicate) -> Observable<[M]> {

        Log.info.log("RealmProtocol: Fetching items with predicate \(predicate)")
        do {
            return try Realm().objects(M.self).filter(predicate).asObservable()
        } catch {
            return Observable<[M]>.error(error)
        }
    }
    
    public func fetchAllItemsWithChanges<M: Object>() -> Observable<RealmCollectionChanges<[M]>> {
        do {
            return try Realm().objects(M.self).asChangesObservable()
        } catch {
            return Observable<RealmCollectionChanges<[M]>>.error(error)
        }
    }
    
    public func fetchItemsWithChanges<M: Object>(predicate: NSPredicate) -> Observable<RealmCollectionChanges<[M]>> {
        do {
            return try Realm().objects(M.self).filter(predicate).asChangesObservable()
        } catch {
            return Observable<RealmCollectionChanges<[M]>>.error(error)
        }
    }
    
    public func addObjectToArray<T: Object>(array: List<T>, object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                array.append(object)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot append object \(T.self)")
        }
    }
    
    public func addObjectsToArray<T: Object>(array: List<T>, objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                array.append(objectsIn: objects)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot append objects \(T.self)")
        }
    }
    
    public func removeObjects<T: Object>(_ objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot delete objects \(T.self)")
        }
    }
    
    public func removeObjects<T: Object>(_ objects: List<T>) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot delete objects \(T.self)")
        }
    }
    
    public func updateValue<T: Object>(_ type: T.Type, value: Any?, forKey key: String) {
        do {
            let realm = try Realm()
            let object = realm.objects(type).first
            try realm.write {
                object?.setValue(value, forKey: key)
            }
        } catch {
            Log.warning.log("RealmProtocol: error \(error.localizedDescription). Cannot update value of object \(T.self)")
        }
    }
}
