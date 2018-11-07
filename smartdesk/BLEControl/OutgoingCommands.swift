//
//  OutgoingCommands.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/17/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A caseless enum that holds all commands sent to the Arduino.
 *  - Make sure there are no duplicates
 *  - As of now the program should only send one character (one byte) at a time
 * for speed purposes. It's a little problematic to send multiple characters
 * at once because Arduino's `readString()` method which reads multi chars is slow
 */
enum OutgoingCommands {
    // desk light
    static let deskLightToggle = "A"
    static let deskLightUpBrightness = "B"
    static let deskLightReduceBrightness = "C"
    static let deskLightUpColorTemp = "D"
    static let deskLightReduceColorTemp = "E"
    static let deskLightColor = "F"
    
    // whiteboard light
    static let whiteboardLightToggle = "G"
    static let whiteboardLightUpBrightness = "H"
    static let whiteboardLightReduceBrightness = "I"
    static let whiteboardLightUpColorTemp = "J"
    static let whiteboardLightReduceColorTemp = "K"
    static let whiteboardLightColor = "L"
    
    // whiteboard movement
    static let whiteboardUp = "M"
    static let whiteboardDown = "N"
    static let whiteboardEraseToggle = "O"
    
    // lockable compartment
    static let lockableToggle = "P"
    
    // outlets
    static let outletToggle = "Q"
    
}
