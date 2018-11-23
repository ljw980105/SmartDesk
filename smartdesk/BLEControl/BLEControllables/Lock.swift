//
//  Lock.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class Lock: NSObject, BLEControllable {
    var sectionHeader: String = "Lockable Compartment"
    var controls: [BLEControlEntity] =
        [BLEControlEntity(name: "Locked",
                          outgoingCommand: OutgoingCommands.lockableToggle,
                          incomingCommands: [.lockableCmptUnlocked, .lockableCmptLocked],
                          switchLabels: ("Locked", "Unlocked"),
                          isBiometric: true)]
}
