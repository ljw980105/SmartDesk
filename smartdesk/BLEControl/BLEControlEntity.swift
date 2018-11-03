//
//  BLEControlEntity.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A struct representing a general cell in the UI. Can be a switch or slider or neither(generic).
 */
struct BLEControlEntity {
    
    enum BLEControlType {
        case customize
        case toggle
        case generic
    }
    
    /** the command used to interact with the ble module.*/
    let outgoingCommand: String?
    /** The name displayed on the cell.*/
    let name: String
    let controlType: BLEControlType
    let incomingCommands: [IncomingCommand]
    let lightControlOptions: [LightControlOptions: String]?
    
    init(name: String,
         outgoingCommand: String? = nil ,
         incomingCommands: [IncomingCommand] = [],
         isSwitch: Bool = false,
         isCustomization: Bool = false,
         lightControlOptions: [LightControlOptions: String]? = nil) {
        self.outgoingCommand = outgoingCommand
        self.incomingCommands = incomingCommands
        self.name = name
        self.lightControlOptions = lightControlOptions
        if isSwitch && isCustomization {
            fatalError("Cannot be both a switch and a customizaiton button")
        } else if isSwitch {
            controlType = .toggle
        } else if isCustomization {
            controlType = .customize
        } else {
            controlType = .generic
        }
    }
}
