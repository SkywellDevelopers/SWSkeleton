//
//  ThreadRunLoopWorker.swift
//  SWSkeleton
//
//  Created by User on 7/23/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Foundation

class ThreadRunLoopWorker: NSObject {
    private var thread: Thread!
    private var block: (() throws ->Void)!
    
    private override init() {
        super.init()
    }
    
    convenience init(label: String) {
        self.init()
        
        thread = Thread { [weak self] in
            while (self != nil && !self!.thread.isCancelled) {
                RunLoop.current.run(
                    mode: RunLoop.Mode.default,
                    before: Date.distantFuture)
            }
            Thread.exit()
        }
        
        thread.name = label
        thread.start()
    }
    
    @objc private func runBlock() throws { try block() }
    
    func job(_ block: @escaping () throws -> Void) {
        self.block = block
        
        perform(#selector(runBlock),
                on: thread,
                with: nil,
                waitUntilDone: false,
                modes: [RunLoop.Mode.default.rawValue])
    }
    
    func stop() {
        thread.cancel()
    }
}
