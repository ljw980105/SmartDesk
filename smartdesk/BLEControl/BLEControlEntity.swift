//
//  BLEControlEntity.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A struct representing a general cell in the UI. Can be a switch or slider or neither.
 */
struct BLEControlEntity {
    
    enum BLEControlType {
        case slider
        case toggle
        case neither
    }
    
    /** the command used to interact with the ble module.*/
    let command: String
    /** The name displayed on the cell.*/
    let name: String
    let controlType: BLEControlType
    
    init(command: String, name: String, isSwitch: Bool = false, isSlider: Bool = false) {
        self.command = command
        self.name = name
        if isSwitch {
            controlType = .toggle
        } else if isSlider {
            controlType = .slider
        } else {
            controlType = .neither
        }
        if isSwitch && isSwitch == isSlider {
            fatalError("This cannot be both a switch and a slider")
        }
    }
}
