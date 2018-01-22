//
//  RxRealmExtensions.swift
//  SWSkeleton
//
//  Created by Misha Korchak on 14.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//
import UIKit
import Foundation
import RxSwift
import RxCocoa
import RealmSwift

public enum RealmCollectionChanges<T> {
    case inserted([Int], T)
    case deleted([Int], T)
    case modificated([Int], T)
    case initial(T)
}

public enum RealmObjectChanges {
    case deleted
    case changed([PropertyChange])
}

extension Object: ObservableConvertibleType {}

public extension Object {
    public func incrementID() -> Int {
        do {
            let realm = try Realm()
            return (realm.objects(type(of: self)).max(ofProperty: "id") as Int? ?? 0) + 1
        } catch {
            return 0
        }
    }
}

public extension ObservableConvertibleType where Self: Object {
    public typealias E = Self?
    
    public func asObservable() -> Observable<Self?> {
        return Observable.create { (observer) -> Disposable in
            let notification = self.observe({ (change) in
                switch change {
                case .change(let changes):
                    changes.forEach({ (change) in
                        self.setValue(change.newValue, forKey: change.name)
                    })
                    observer.on(.next((self)))
                case .deleted:
                    observer.on(.next(nil))
                case.error(let error):
                    observer.on(.error(error))
                }
            })
            
            return Disposables.create {
                notification.invalidate()
            }
        }
    }
    
    public func asPropertyChangeObservable() -> Observable<RealmObjectChanges> {
        return Observable.create { observer in
            let notification = self.observe { (change) in
                switch change {
                case .change(let changes):
                    observer.on(.next(.changed(changes)))
                case .deleted:
                    observer.on(.next(.deleted))
                case.error(let error):
                    observer.on(.error(error))
                }
            }
            
            return Disposables.create {
                notification.invalidate()
            }
        }
    }
}

public extension RealmCollection {
    
    public func asChangesObservable() -> Observable<RealmCollectionChanges<[Element]>> {
        return Observable.create { observer in
            let notification = self.observe({ (change) in
                
                switch change {
                case .error(let error):
                    observer.on(.error(error))
                case .initial(let array):
                    observer.on(.next(.initial(array.map({ $0 }))))
                case .update(let array, deletions: let deleted, insertions: let inserted, modifications: let modificated):
                    
                    if deleted.count > 0 {
                        observer.on(.next(.deleted(deleted, array.map({ $0 }))))
                    }
                    if inserted.count > 0 {
                        observer.on(.next(.inserted(inserted, array.map({ $0 }))))
                    }
                    if modificated.count > 0 {
                        observer.on(.next(.modificated(modificated, array.map({ $0 }))))
                    }
                }
            })
            
            return Disposables.create {
                notification.invalidate()
            }
        }
    }
    
    public func asObservable() -> Observable<[Element]> {
        return Observable.create { observer in
            return self.asChangesObservable().subscribe(onNext: { (changes) in
                switch changes {
                case .deleted(_, let array):
                    observer.onNext(array)
                case .inserted(_, let array):
                    observer.onNext(array)
                case .modificated(_, let array):
                    observer.onNext(array)
                case .initial(let array):
                    observer.onNext(array)
                }
                
            }, onError: observer.onError(_:), onCompleted: observer.onCompleted)
        }
    }
}
