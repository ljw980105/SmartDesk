//
//  BLEManagerDelegate.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

protocol BLEManagerDelegate: class {
    func didConnectToSmartDesk()
    func didDisconnectFromSmartDesk()
    func didFailSmartDeskConnection()
    func readyToSendData()
    func didReceiveError(error: Error?)
}

/** Provides optional methods with protocol extensions */
extension BLEManagerDelegate {
    func didConnectToSmartDesk() {}
    func didDisconnectFromSmartDesk() {}
    func didFailSmartDeskConnection() {}
    func readyToSendData() {}
    func didReceiveError(error: Error?) {}
}
