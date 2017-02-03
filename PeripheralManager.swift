//
//  PeripheralManager.swift
//
//  Created by Alex Tarragó on 04/11/2016.
//  Copyright © 2016 KIASU. All rights reserved.
//

import CoreBluetooth

private let sharedManager = KiasuSDK()

class KiasuSDK: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var central_manager: CBCentralManager! = nil
    private var scanning: Bool = false
    private var sdkStatus: KiasuSDKProcessStatus = .UnknownStatus
    
    // Singleton instance
    class var sharedInstance: KiasuSDK {
        struct Static {
            static let instance: KiasuSDK = KiasuSDK()
        }
        return Static.instance
    }
    
    // CBManager Helpers
    func discover() {
        if central_manager == nil {
            central_manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true, CBCentralManagerOptionShowPowerAlertKey: true])
        }
    }
    func stop() {
        scanning = false
        if central_manager != nil {
            central_manager.stopScan()
        }
    }
    func isScanning() -> Bool {
        return scanning
    }
    
    func readValue(characteristic: CBCharacteristic!) {
        if characteristic != nil {
            current_kiasu.peripheral.readValue(for: characteristic)
            current_kiasu.peripheral.setNotifyValue(true, for: characteristic)
        } else {
            current_kiasu.peripheral.discoverServices(nil)
        }
    }
    func writeValue(characteristic: CBCharacteristic!, rawData: Data!) {
        if characteristic != nil {
            peripheral.delegate = self
            peripheral.writeValue(rawData, for: characteristic, type: .withResponse)
        }
    }
    func scan(central: CBCentralManager!) {
        if central != nil {
            scanning = true
            central_manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        } else {
            discover()
        }
    }
    func failed(central: CBCentralManager) {
        sdkStatus = .UnknownStatus
    }
    
    // Central Manager Delegate Methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            scan(central: central_manager)
        } else {
            scanning = false
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Do whatever you want with the discovered peripheral
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        failed(central: central)
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        klog(message: "Connection failed - \(sdkStatus)")
        failed(central: central)
    }

    
    // Peripheral Delegate Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    
    }
}