//
//  OutgoingCommands.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/17/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A caseless enum that holds all commands sent to the Arduino
 *  - Make sure there are no duplicates
 *  - As of now the program can only send one character (one byte) at a time
 */
enum OutgoingCommands {
    // desk light
    static let deskLightToggle = "A"
    static let deskLightUpBrightness = "B"
    static let deskLightReduceBrightness = "C"
    static let deskLightUpColorTemp = "D"
    static let deskLightReduceColorTemp = "E"
    static let deskLightColorRed = "F"
    static let deskLightColorGreen = "G"
    static let deskLightColorBlue = "H"
    static let deskLightColorYellow = "I"
    static let deskLightColorWhite = "J"
    
}
