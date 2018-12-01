//
//  WhiteboardMovement.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class WhiteboardMovement: NSObject, BLEControllable {
    var sectionHeader: String = "Whiteboard"
    var controls: [BLEControlEntity] =
        [BLEControlEntity(name: "Up", longProcessCommands: (OutgoingCommands.whiteboardUp,OutgoingCommands.whiteboardStop)),
         BLEControlEntity(name: "Down", longProcessCommands: (OutgoingCommands.whiteboardDown,OutgoingCommands.whiteboardStop)),
         BLEControlEntity(name: "Eraser Off", outgoingCommand: OutgoingCommands.whiteboardEraseToggle,
                          incomingCommands: [.whiteboardEraseOff, .whiteboardEraseOn],
                          switchLabels: ("Eraser Off", "Eraser On"))]
    
}
