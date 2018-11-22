//
//  BLEControlEntity.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A class representing a general cell in the UI. Can be a switch or customizable or neither(generic).
 */
class BLEControlEntity: NSObject {
    
    enum BLEControlType {
        case customize
        case biometric
        case toggle
        case generic
        case longProcess
    }
    
    /** the command used to interact with the ble module.*/
    let outgoingCommand: String?
    /** The name displayed on the cell. It's variable as the DS needs to be updated.*/
    var name: String
    let controlType: BLEControlType
    let incomingCommands: [IncomingCommand]
    let lightControlOptions: [LightControlOptions: String]?
    
    /** first str is the on label, and the second is the off label.
     The `isSwitch` property will be true if this param is set. */
    let switchLabels: (String, String)?
    
    /** First string is the start command, and the second is the stop command.*/
    let longProcessCommands: (String, String)?
    
    init(name: String,
         outgoingCommand: String? = nil ,
         incomingCommands: [IncomingCommand] = [],
         switchLabels: (String, String)? = nil,
         isCustomization: Bool = false,
         isBiometric: Bool = false,
         lightControlOptions: [LightControlOptions: String]? = nil,
         longProcessCommands: (String, String)? = nil) {
        self.outgoingCommand = outgoingCommand
        self.incomingCommands = incomingCommands
        self.name = name
        self.lightControlOptions = lightControlOptions
        self.switchLabels = switchLabels
        self.longProcessCommands = longProcessCommands
        
        let isSwitch = switchLabels != nil
        if isSwitch && isBiometric {
            controlType = .biometric
        } else if isSwitch {
            controlType = .toggle
        } else if isCustomization {
            controlType = .customize
        } else if longProcessCommands != nil {
            controlType = .longProcess
        } else {
            controlType = .generic
        }
        super.init()
    }
    
    override var debugDescription: String {
        return "name: \(name), outgoingCommand: \(outgoingCommand ?? "")," +
        " switchLabels: (\(switchLabels?.0 ?? ""),\(switchLabels?.1 ?? ""))"
    }
}
