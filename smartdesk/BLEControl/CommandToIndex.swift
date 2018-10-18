//
//  CommandToIndex.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/18/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class CommandToIndex {
    /** Look up table to conveniently look up a command's view in the vc.*/
    static var currentTable: [IncomingCommand: CommandToIndex] = [:]
    
    let command: IncomingCommand
    /** Section in the table view*/
    let indexInTableView: Int
    /** IndexPath in the collection view (contaiend in the tableView cell) */
    let collecIndexPath: IndexPath
    
    init(cmd: IncomingCommand, tableViewIndex: Int, collecIndexPath: IndexPath) {
        command = cmd
        indexInTableView = tableViewIndex
        self.collecIndexPath = collecIndexPath
    }
}
