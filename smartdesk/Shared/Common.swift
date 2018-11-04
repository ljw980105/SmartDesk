//
//  Common.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/3/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    private static let transitionAnimationKey = "transitionAnimationNeeded"
    
    class var isTransitionAnimationNeeded: Bool {
        return self.standard.bool(forKey: transitionAnimationKey)
    }
    
    class func setTransitionAnimationNeeded() {
        self.standard.set(true, forKey: transitionAnimationKey)
    }
    
    class func setTransitionAnimationNotNeeded() {
        self.standard.set(false, forKey: transitionAnimationKey)
    }
}

extension UIColor {
    static let themeColor = UIColor(red: 23/255, green: 38/255, blue: 245/255, alpha: 1)
}
