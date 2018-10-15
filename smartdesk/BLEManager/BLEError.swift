//
//  BLEError.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BLEError {
    case genericError(error: Error?)
    case bluetoothOff
    case timeOut
    case peripheralDisconnected
    case unexpected
    
    func showErrorMessage() {
        switch self {
        case .genericError(let error):
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: error?.localizedDescription ?? "")
        case .bluetoothOff:
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Bluetooth is off")
        case .timeOut:
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Connection timed out")
        case .peripheralDisconnected:
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Bluetooth Device Disconnected")
        case .unexpected:
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Unexpected Error Encountered")
        }
    }
    
    static func error(fromBLEState state: CBManagerState) -> BLEError? {
        switch state {
        case .unknown:
            return .genericError(error: NSError(domain: "Unknown error", code: 0, userInfo: [:]))
        case .resetting:
            return .genericError(error: NSError(domain: "Resetting", code: 0, userInfo: [:]))
        case .unsupported:
            return .genericError(error: NSError(domain: "Unsupported", code: 0, userInfo: [:]))
        case .unauthorized:
            return .genericError(error: NSError(domain: "Unauthorized", code: 0, userInfo: [:]))
        case .poweredOff:
            return .bluetoothOff
        default:
            return nil
        }
    }
}
