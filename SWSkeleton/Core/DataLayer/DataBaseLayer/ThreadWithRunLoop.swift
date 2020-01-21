//
//  ThreadWithRunLoop.swift
//  SWSkeleton
//
//  Created by Alexei Gordienko on 12/26/19.
//  Copyright © 2019 Korchak Mykhail. All rights reserved.
//

import Foundation


public final class ThreadWithRunLoop: Thread {
    
    private(set) var runLoop: RunLoop!
    
    override public func main() {
        self.runLoop = RunLoop.current
        self.runLoop.add(Port(), forMode: .common)
        self.runLoop.run()
    }
}
