//
//  TimeoutableOperation.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/11/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class TimeoutableOperation: Operation {
    let codeToExecute: () -> Void
    let timeOutInterval: TimeInterval
    
    init(timeOut: TimeInterval, execution: @escaping () -> Void) {
        codeToExecute = execution
        timeOutInterval = timeOut
    }
    
    override func main() {
        // no need to weakify self in this case
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + timeOutInterval as DispatchTime) {
            if !self.isCancelled {
                self.codeToExecute()
            }
        }
    }
}
