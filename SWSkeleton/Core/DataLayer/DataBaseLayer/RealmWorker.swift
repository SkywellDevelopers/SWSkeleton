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
    public static let shared = RealmWorker(realmConfiguration: .defaultConfiguration, name: "SharedRealmDB")
    
    enum Error: Swift.Error {
        case realmCreationFailed
        case writeTransactionFailed
    }
    
    public enum EitherReferenceObject<T: Object> {
        case object(T)
        case reference(ThreadSafeReference<T>)
        
        public func resolve(on realm: Realm) -> T? {
            switch self {
            case .object(let object): return object
            case .reference(let ref): return realm.resolve(ref)
            }
        }
    }
    
    private let _realmConfiguration: Realm.Configuration
    private let _threadScheduler: ThreadSchedulerWithRunLoop
    private let _concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    public init(realmConfiguration: Realm.Configuration, name: String) {
        self._realmConfiguration = realmConfiguration
        self._threadScheduler = ThreadSchedulerWithRunLoop(name: name)
    }
    
    public func safeWrite(_ closure: @escaping (Realm) -> Void) -> Single<()> {
        return Single
            .create(subscribe: { eventHandler in
                let cancelable = Disposables.create()

                guard let realm = try? Realm(configuration: self._realmConfiguration) else {
                    eventHandler(.error(Error.realmCreationFailed))
                    return cancelable
                }

                if let _ = try? realm.safeWrite ({ closure(realm) }) { eventHandler(.success(())) }
                else { eventHandler(.error(Error.writeTransactionFailed)) }
                
                return cancelable
            })
            .subscribeOn(self._threadScheduler)
        
    }
    
    public func asyncSafeWrite(_ closure: @escaping (Realm) -> Void) {
        self._threadScheduler.perform {
            guard let realm = try? Realm(configuration: self._realmConfiguration) else { return }
            closure(realm)
        }
    }
    
    private func _observation<T>(_ closure: @escaping (Realm) -> Observable<T>) -> Observable<T> {
        return Observable
            .create({ observer in
                var subscription: Disposable?
                let cancelable = Disposables.create { subscription?.dispose() }
                
                guard let realm = try? Realm(configuration: self._realmConfiguration) else {
                    observer.onError(Error.realmCreationFailed)
                    return cancelable
                }
                guard !cancelable.isDisposed else { return cancelable }
                subscription = closure(realm).subscribe(observer)
                
                return cancelable
            })
    }
    
    public func safeObservation<T>(_ closure: @escaping (Realm) -> Observable<T>) -> Observable<T> {
        return self._observation(closure).subscribeOn(self._threadScheduler)
    }
    
    public func unsafeObservation<T>(_ closure: @escaping (Realm) -> Observable<T>) -> Observable<T> {
        return self._observation(closure).subscribeOn(self._concurrentScheduler)
    }
    
    public func unsafeWork<T>(_ closure: (Realm) throws -> T) throws -> T {
        let realm  = try Realm(configuration: self._realmConfiguration)
        return try closure(realm)
    }
    
    public static func reference<T: ThreadConfined>(to object: T) -> ThreadSafeReference<T>? {
        return object.realm.map { _ in ThreadSafeReference(to: object) }
    }
    
    public static func eitherReferenceObject<T: Object>(to object: T) -> EitherReferenceObject<T> {
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

