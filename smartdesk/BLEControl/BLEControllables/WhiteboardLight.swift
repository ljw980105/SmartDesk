//
//  WhiteboardLight.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/5/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class WhiteboardLight: NSObject, BLEControllable {
    var sectionHeader: String = "Whiteboard Light"
    var controls: [BLEControlEntity] = []
    
    override init() {
        super.init()
        controls.append(BLEControlEntity(name: "On",
                                         outgoingCommand: OutgoingCommands.whiteboardLightToggle,
                                         incomingCommands: [.whiteboardLightOff, .whiteboardLightOn],
                                         switchLabels: ("On", "Off")))
        
        var lightControls: [LightControlOptions: String] = [:]
        lightControls[.higherColorTemp] = OutgoingCommands.whiteboardLightUpColorTemp
        lightControls[.lowerColorTemp] = OutgoingCommands.whiteboardLightReduceColorTemp
        lightControls[.higherBrightness] = OutgoingCommands.whiteboardLightUpBrightness
        lightControls[.lowerBrightness] = OutgoingCommands.whiteboardLightReduceBrightness
        lightControls[.colorKeys] = OutgoingCommands.whiteboardLightColor
        lightControls[.persistentName] = "WhiteboardLight"
        
        controls.append(BLEControlEntity(name: "Customize", isCustomization: true,
                                         lightControlOptions: lightControls))
    }
    
}
