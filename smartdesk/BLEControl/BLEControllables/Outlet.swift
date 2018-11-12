//
//  Outlet.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class Outlet: NSObject, BLEControllable {
    var sectionHeader: String = "Outlets"
    var controls: [BLEControlEntity] =
        [BLEControlEntity(name: "Front",
                          outgoingCommand: OutgoingCommands.outletToggle,
                          incomingCommands: [.outletsFacingSide, .outletsFacingFront],
                          switchLabels: ("Front", "Side"))]
}
