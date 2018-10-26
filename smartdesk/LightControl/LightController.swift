//
//  LightController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/23/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

class LightController {
    let data: [[String]]
    let sectionHeaders = ["Brightness", "Warmth", "Colors"]
    
    let colors = [UIColor.white, UIColor.red, UIColor.green,
                  UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.orange]
    
    init(data: [LightControlOptions: String]) {
        var brightnessControls = [String]()
        brightnessControls.append(data[LightControlOptions.higherBrightness] ?? "")
        brightnessControls.append(data[LightControlOptions.lowerBrightness] ?? "")
        var tempControls = [String]()
        tempControls.append(data[LightControlOptions.higherColorTemp] ?? "")
        tempControls.append(data[LightControlOptions.lowerColorTemp] ?? "")
        var final: [[String]] = []
        final.append(brightnessControls)
        final.append(tempControls)
        final.append([data[LightControlOptions.colorKeys] ?? ""])
        self.data = final
    }
}
