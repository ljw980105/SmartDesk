//
//  DashboardController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardController: NSObject {
    var bleControls: [BLEControllable] = []
    let controls: [BLEControllable] = [WhiteboardLight(), WhiteboardMovement(), DeskLight(),
                                       Lock(), Outlet()]
    
    override init() {
        super.init()
    }
    
    func lightControl(in section: Int) -> [LightControlOptions : String]? {
        return bleControls[section].controls.filter { $0.lightControlOptions != nil }.first?.lightControlOptions
    }
    
    /** perform updates on the data structure to make sure they are re-dequeued correctly */
    func updateData(cmdToIndex: CommandToIndex, cell: DashboardSlidableTableViewCell) {
        let objectToModify = cell.controllableObject?.controls[cmdToIndex.collecIndexPath.row]
        if let switchLabels = objectToModify?.switchLabels {
            let originalName = objectToModify?.name ?? ""
            var updatedName = ""
            if originalName == switchLabels.0 {
                updatedName = switchLabels.1
            } else if originalName == switchLabels.1 {
                updatedName = switchLabels.0
            }
            bleControls[cmdToIndex.indexInTableView].controls[cmdToIndex.collecIndexPath.row].name = updatedName
        }
    }
    
}
