//
//  ThreadSchedulerWithRunLoop.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 12/26/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Foundation
import RxSwift

public final class ThreadSchedulerWithRunLoop: ImmediateSchedulerType {
    private let thread: ThreadWithRunLoop
    
    public init(name: String) {
        self.thread = ThreadWithRunLoop()
        self.thread.name = name
        self.thread.start()
        
        while self.thread.runLoop == nil {
            print("!!!!!Waiting for runLoop \(name) initialization")
        }
    }
    
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let disposable = SingleAssignmentDisposable()
        
        self.thread.runLoop.perform {
            disposable.setDisposable(action(state))
        }
        
        return disposable
    }
    
    public func perform(_ block: @escaping () -> Void) {
        self.thread.runLoop.perform(block)
    }
}
