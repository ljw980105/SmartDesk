//
//  LightControlSliderTableViewCell.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/24/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class LightControlSliderTableViewCell: UITableViewCell {
    @IBOutlet weak var lightSlider: UISlider!
    static let identifier = "lightControlSlider"
    
    private var incrementCommand: String = ""
    private var decrementCommand: String = ""
    private var function: LightSliderFunction = .brightness
   
    private var previousValue: Float = 50
    
    func setUp(upCommand: String,
               downCommand: String,
               function: LightSliderFunction,
               databaseManager: LightControlPersistenceManager) {
        incrementCommand = upCommand
        decrementCommand = downCommand
        self.function = function
        var persistenceValue: Float = 0.0
        switch self.function {
        case .warmth:
            lightSlider.minimumTrackTintColor = UIColor.cyan
            lightSlider.maximumTrackTintColor = UIColor.orange
            persistenceValue = databaseManager.colorTemperature
        case .brightness:
            lightSlider.minimumTrackTintColor = UIColor.black
            lightSlider.maximumTrackTintColor = UIColor.lightGray
            persistenceValue = databaseManager.brightness
        }
        previousValue = persistenceValue
        lightSlider.value = persistenceValue
    }

    @IBAction func lightSliderChanged(_ sender: UISlider) {
        guard abs(Int(sender.value)) != Int(previousValue) else { return }
        if abs(Int(sender.value)) % 10 == 0 {
            if sender.value > previousValue {
                BLEManager.current.send(string: incrementCommand)
            } else if sender.value < previousValue {
                BLEManager.current.send(string: decrementCommand)
            }
            previousValue = sender.value
            Haptic.current.beepLightly()
        }
    }
}
