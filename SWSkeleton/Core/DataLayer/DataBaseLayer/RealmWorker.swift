//
//  RealmWorker.swift
//  SWSkeleton
//
//  Created by User on 7/23/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import RealmSwift
import RxSwift

public final class RealmWorker {
    
    enum Error: Swift.Error {
        case realmCreationFailed
        case writeTransactionFailed
    }
    
    public enum EitherReferenceObject<T: Object> {
        case object(T)
        case reference(ThreadSafeReference<T>)
    }
    
    static private let internalQueue = DispatchQueue(label: "RealmDBInternalQueue")
    static private let internalThread = ThreadRunLoopWorker(label: "RealmDBInternalThread")
    
    private init() { }
    
    static public func safeWrite(_ closure: @escaping (Realm) throws -> Void) -> Single<()> {
        return Single.create { [worker = self] eventHander in
            worker.internalQueue.async {
                worker.internalThread.job { autoreleasepool {
                    guard let realm = try? Realm() else {
                        eventHander(.error(Error.realmCreationFailed))
                        return
                    }
                    if let _ = try? realm.safeWrite ({ try closure(realm) }) {
                        eventHander(.success(()))
                    } else {
                        eventHander(.error(Error.writeTransactionFailed))
                    }
                    }}
            }
            
            return Disposables.create()
        }
    }
    
    static public func safeObservation<T>(_ closure: @escaping (Realm) -> Observable<T>) -> Observable<T> {
        return Observable.create { [worker = self] observer in
            var subscription: Disposable?
            let cancelable = Disposables.create { subscription?.dispose() }
            
            worker.internalQueue.async {
                worker.internalThread.job { try? autoreleasepool {
                    guard !cancelable.isDisposed else { return }
                    let realm = try Realm()
                    subscription = closure(realm).subscribe(observer)
                    }}
            }
            
            return cancelable
        }
    }
    static public func unsafeWork<T>(_ closure: (Realm) throws -> T) throws -> T {
        let realm  = try Realm()
        return try closure(realm)
    }
    
    static public func reference<T: ThreadConfined>(to object: T) -> ThreadSafeReference<T>? {
        return object.realm.map { _ in ThreadSafeReference(to: object) }
    }
    
    static public func eitherReferenceObject<T: Object>(to object: T) -> EitherReferenceObject<T> {
        guard let ref = self.reference(to: object) else { return EitherReferenceObject.object(object) }
        return EitherReferenceObject.reference(ref)
    }
}

fileprivate extension Realm {
    func safeWrite(_ writing: @escaping () throws -> Void) throws {
        if self.isInWriteTransaction { try writing() }
        else { try self.write(writing) }
    }
}

