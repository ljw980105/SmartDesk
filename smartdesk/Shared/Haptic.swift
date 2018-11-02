//
//  Haptic.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/24/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

/**
 * Singleton class to generate a medium impact haptic feedback
 */
class Haptic {
    static let current = Haptic()
    
    private var haptic: UIImpactFeedbackGenerator
    private var selectionHaptic: UISelectionFeedbackGenerator
    
    private init() {
        haptic = UIImpactFeedbackGenerator(style: .medium)
        selectionHaptic = UISelectionFeedbackGenerator()
    }
    
    /** Generate a haptic feedback */
    func beep() {
        haptic.impactOccurred()
    }
    
    func beepLightly() {
        selectionHaptic.selectionChanged()
    }
}
