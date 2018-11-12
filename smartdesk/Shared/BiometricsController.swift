//
//  BiometricsController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/13/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import LocalAuthentication

/**
   A caseless enum containing the operations related to logging in with TouchID / FaceID.
 - After the user logs in for the first time, ask if the user wants to use biometrics
     - If so, save the user's username & password
     - Upon subsequent launches the device prompts biometric login. Successful authentications
       will attempt to login with the saved passwords to our servers
 - Resetting the biometrics will restart the process described above
 */
enum BiometricsController {
    
    private static var context: LAContext = {
        let contextToConfig = LAContext()
        contextToConfig.localizedCancelTitle = "Cancel"
        return contextToConfig
    }()
    
    static func isBiometricAvailable() -> Bool {
        return self.context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    static func authenticateWithBiometrics(onSuccess successHandler: @escaping () -> Void,
                                           onError errorHandler: @escaping (Error?) -> Void = { _ in }) {
        self.context.evaluatePolicy(.deviceOwnerAuthentication,
                                    localizedReason: "Unlock") { success, error in
            DispatchQueue.main.async {
                if success {
                    resetContext()
                    successHandler()
                } else {
                    errorHandler(error)
                }
            }
        }
    }
    
    static func biometricMode() -> String {
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none: return "None"
            // the rest shouldn't be localized as they are names of Apple Services
            case .touchID: return "Touch ID"
            case .faceID: return "Face ID"
            }
        }
        return "Touch ID"
    }
    
    // MARK: - Private
    
    /**
     * Need to reset the context so that LAContext will require authentication everytime.
     */
    private static func resetContext() {
        self.context = LAContext()
        self.context.localizedCancelTitle = "Cancel"
    }
}
