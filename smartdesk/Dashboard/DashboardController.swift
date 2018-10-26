//
//  DashboardController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardController: NSObject {
    let bleControls: [BLEControllable] = [DeskLight()]
    
    override init() {
        super.init()
    }
    
    func lightControl(in section: Int) -> [LightControlOptions : String]? {
        return bleControls[section].controls.filter{ $0.lightControlOptions != nil }.first?.lightControlOptions
    }
    
}
