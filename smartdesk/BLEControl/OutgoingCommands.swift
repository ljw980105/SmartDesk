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
    static let deskLightToggle = "A"
}
