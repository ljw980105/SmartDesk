//
//  BLEManager.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 * Note: dispatch to the main thread when interacting with this class
 */
class BLEManager: NSObject {
    
    static let current = BLEManager()
    
    private var bluetoothManager: CBCentralManager!
    private var smartDesk: CBPeripheral?
    private var smartDeskDataPoint: CBCharacteristic?
    
    private let bleModuleUUID = CBUUID(string: "0xFFE0") // gorgeous!
    private let bleCharacteristicUUID = CBUUID(string: "0xFFE1")
    
    weak var delegate: BLEManagerDelegate?
    
    override init() {
        super.init()
        bluetoothManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .userInitiated))
    }
    
    // MARK: Instance methods
    func connect() {
        bluetoothManager.scanForPeripherals(withServices: [bleModuleUUID], options: nil)
    }
    
    func disconnect() {
        if let smartDeskUnwrapped = smartDesk {
            bluetoothManager.cancelPeripheralConnection(smartDeskUnwrapped)
            smartDesk = nil
            smartDeskDataPoint = nil
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didDisconnectFromSmartDesk()
            }
        }
    }
    
    func send(data stringData: String) {
        guard let peripheral = smartDesk, let characteristic = smartDeskDataPoint else {
            print("Not ready to send data")
            return
        }
        peripheral.writeValue(stringData.data(using: String.Encoding.utf8)!,
                              for: characteristic, type: .withoutResponse)
    }
}

extension BLEManager: CBCentralManagerDelegate {
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("BLE Manager Unknown State")
        case .resetting:
            print("BLE Manager Reset State")
        case .unsupported:
            print("BLE Manager Unsupported State")
        case .unauthorized:
            print("BLE Manager Unauthorized State")
        case .poweredOff:
            print("BLE Manager Powered off State")
        case .poweredOn:
            print("BLE Manager Powered on State")
            bluetoothManager.scanForPeripherals(withServices: [bleModuleUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name == "SH-HC-08" else { return }
        print(peripheral.debugDescription)
        smartDesk = peripheral
        bluetoothManager.stopScan()
        bluetoothManager.connect(smartDesk!)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        smartDesk?.delegate = self
        smartDesk?.discoverServices([bleModuleUUID])
    }
}

extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        guard services.count == 1 else {
            print("Should only have 1 service")
            return
        }
        peripheral.discoverCharacteristics([bleCharacteristicUUID], for: services.first!)
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard error == nil else {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveError(error: error)
            }
            return
        }
        guard let characteristics = service.characteristics, characteristics.count == 1 else { return }
        smartDeskDataPoint = characteristics.first!
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.readyToSendData()
        }
        
    }
}
