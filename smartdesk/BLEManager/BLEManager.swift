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
    
    weak var delegate: BLEManagerDelegate?
    
    private var bluetoothManager: CBCentralManager!
    private var smartDesk: CBPeripheral?
    private var smartDeskDataPoint: CBCharacteristic?
    
    private let bleModuleUUID = CBUUID(string: "0xFFE0") // gorgeous!
    private let bleCharacteristicUUID = CBUUID(string: "0xFFE1")
    
    // if the connection request last more than 5s, then let the delegate know of the timeout error.
    private let timeOutInterval: TimeInterval = 5.0
    private var timeOutTimer: Timer?
    
    override init() {
        super.init()
        bluetoothManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .userInitiated))
    }
    
    // MARK: Instance methods
    func connect() {
        if bluetoothManager.state == .poweredOn {
            bluetoothManager.scanForPeripherals(withServices: [bleModuleUUID], options: nil)
            timeOutTimer = Timer.scheduledTimer(withTimeInterval: timeOutInterval,
                                                repeats: false) { [weak self] _ in
                self?.delegate?.didReceiveError(error: .timeOut)
                self?.bluetoothManager.stopScan()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.didReceiveError(error:
                        BLEError.error(fromBLEState: strongSelf.bluetoothManager.state))
                }
            }
        }
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
    
    func send(string: String) {
        guard let peripheral = smartDesk, let characteristic = smartDeskDataPoint else {
            print("Not ready to send data")
            return
        }
        // note: will not work using the .withResponse type
        peripheral.writeValue(string.data(using: String.Encoding.utf8)!,
                              for: characteristic, type: .withoutResponse)
    }
}

extension BLEManager: CBCentralManagerDelegate {
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        handle(updatedState: central.state)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.debugDescription)
        // if you rename the ble module, there will be a newline. Be sure to remove it
        guard peripheral.name?.trimmingCharacters(in: .newlines) == "Hexapi" else { return }
        smartDesk = peripheral
        bluetoothManager.stopScan()
        bluetoothManager.connect(smartDesk!)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        smartDesk?.delegate = self
        smartDesk?.discoverServices([bleModuleUUID])
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didReceiveError(error: .peripheralDisconnected)
        }
    }
    
    func handle(updatedState state: CBManagerState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .poweredOff:
                print("BLE Manager Powered off State")
                self?.delegate?.didReceiveError(error: .bluetoothOff)
            case .poweredOn:
                print("BLE Manager Powered on State")
                self?.delegate?.didPrepareToConnect()
            default:
                if let error = BLEError.error(fromBLEState: state) {
                    self?.delegate?.didReceiveError(error: error)
                }
            }
        }
    }
}

extension BLEManager: CBPeripheralDelegate {
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        guard services.count == 1 else {
            delegate?.didReceiveError(error: .genericError(error:
                NSError(domain: "Should only have 1 service", code: 0, userInfo: [:])))
            return
        }
        peripheral.discoverCharacteristics([bleCharacteristicUUID], for: services.first!)
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard error == nil else {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveError(error: .genericError(error: error))
            }
            return
        }
        guard let characteristics = service.characteristics, characteristics.count == 1 else {
            delegate?.didReceiveError(error: .unexpected)
            return
        }
        smartDeskDataPoint = characteristics.first!
        // at this point, cancel the timeout error message
        timeOutTimer?.invalidate()
        // listen for values sent from the BLE module
        smartDesk?.setNotifyValue(true, for: smartDeskDataPoint!)
        // write a value to wake up the module, since it always start working at the 2nd write
        // send(string: "_")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.readyToSendData()
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let data = characteristic.value, let str = String(data: data, encoding: String.Encoding.utf8) {
            print("Received data is \(str)")
        }
    }
}
