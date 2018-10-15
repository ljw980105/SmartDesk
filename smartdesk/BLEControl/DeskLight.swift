//
//  DeskLight.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

class DeskLight: NSObject, BLEControllable {
    var containsSlider: Bool = false
    var sectionHeader: String = "Desk Light"
    var controls: [BLEControlEntity] = [BLEControlEntity(command: "A", name: "On", isSwitch: true)]
    
    override init() {
        super.init()
    }
    
}
