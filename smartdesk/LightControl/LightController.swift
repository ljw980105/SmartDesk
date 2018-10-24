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
    private let colors: [String: UIColor] = [OutgoingCommands.deskLightColorRed: UIColor.red,
                                             OutgoingCommands.deskLightColorGreen: UIColor.green,
                                             OutgoingCommands.deskLightColorBlue: UIColor.blue,
                                             OutgoingCommands.deskLightColorYellow: UIColor.yellow,
                                             OutgoingCommands.deskLightColorWhite: UIColor.white]
    
    init(data: [LightControlOptions: [String]]) {
        var brightnessControls = [String]()
        brightnessControls.append(contentsOf: data[LightControlOptions.higherBrightness] ?? [])
        brightnessControls.append(contentsOf: data[LightControlOptions.lowerBrightness] ?? [])
        var tempControls = [String]()
        tempControls.append(contentsOf: data[LightControlOptions.higherColorTemp] ?? [])
        tempControls.append(contentsOf: data[LightControlOptions.lowerColorTemp] ?? [])
        var final: [[String]] = []
        final.append(brightnessControls)
        final.append(tempControls)
        final.append(data[LightControlOptions.colorKeys] ?? [])
        self.data = final
    }
    
    func color(from colorStrings: String) -> UIColor? {
        //return colors[colorStrings.components(separatedBy: "-").last ?? ""]
        return colors[colorStrings]
    }

}
