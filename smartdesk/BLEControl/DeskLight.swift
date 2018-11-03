//
//  DeskLight.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class DeskLight: NSObject, BLEControllable {
    var sectionHeader: String = "Desk Light"
    var controls: [BLEControlEntity] = []
    
    override init() {
        super.init()
        controls.append(BLEControlEntity(name: "On",
                                         outgoingCommand: OutgoingCommands.deskLightToggle,
                                         incomingCommands: [.deskLightOff, .deskLightOn],
                                         isSwitch: true))
        
        var lightControls: [LightControlOptions: String] = [:]
        lightControls[.higherColorTemp] = OutgoingCommands.deskLightUpColorTemp
        lightControls[.lowerColorTemp] = OutgoingCommands.deskLightReduceColorTemp
        lightControls[.higherBrightness] = OutgoingCommands.deskLightUpBrightness
        lightControls[.lowerBrightness] = OutgoingCommands.deskLightReduceBrightness
        lightControls[.colorKeys] = OutgoingCommands.deskLightColor
        
        controls.append(BLEControlEntity(name: "Customize", isCustomization: true,
                                         lightControlOptions: lightControls))
    }
    
}
