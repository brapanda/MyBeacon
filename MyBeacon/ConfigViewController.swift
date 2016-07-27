//
//  ConfigViewController.swift
//  MyBeacon
//
//  Created by Shawn on 2016-01-27.
//  Copyright © 2016 Shawn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

class ConfigViewController: UIViewController, CBPeripheralManagerDelegate {
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var UUID       = UILabel()
    var Major      = UILabel()
    var Minor      = UILabel()
    var idenitity  = UILabel()
    var transmitButton : UIButton!
    
    var beaconRegion         = CLBeaconRegion()
    var beaconPeripheralData = NSDictionary()
    var peripheralManager    = CBPeripheralManager()
    var uuidT                = "206A2476-D4DB-42F0-BF73-030236F2C756"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UUID.frame.size         = CGSize(width: 200, height: 50)
        UUID.frame.origin       = CGPoint(x: screenSize.width/2 - 100, y: 100)
        UUID.text               = "UUID:"
        
        Major.frame.size        = CGSize(width: 200, height: 50)
        Major.frame.origin      = CGPoint(x: screenSize.width/2 - 100, y: 150)
        Major.text              = "Major:"
        
        Minor.frame.size        = CGSize(width: 200, height: 50)
        Minor.frame.origin      = CGPoint(x: screenSize.width/2 - 100, y: 200)
        Minor.text              = "Minor:"
        
        idenitity.frame.size    = CGSize(width: 200, height: 50)
        idenitity.frame.origin  = CGPoint(x: screenSize.width/2 - 100, y: 250)
        idenitity.text          = "idenitity:"
        
        transmitButton = UIButton()
        transmitButton.frame.size    = CGSize(width: 50, height: 50)
        transmitButton.frame.origin  = CGPoint(x: screenSize.width/2 - 25, y: 350)
        transmitButton.backgroundColor = UIColor.blackColor()
        transmitButton.layer.cornerRadius = 25
        transmitButton.addTarget(self, action: "transmitAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(UUID)
        self.view.addSubview(Major)
        self.view.addSubview(Minor)
        self.view.addSubview(idenitity)
        self.view.addSubview(transmitButton)
        
        self.initBeacon()
        self.setLabels()

    }
    
    func initBeacon(){
//        let uuidTT = (uuidT != "") ? uuidT : "206A2476-D4DB-42F0-BF73-030236F2C756"
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuidT)!, major: 1, minor: 1, identifier: "com.mybeacon.region")
    }
    
    func transmitAction(){
        self.beaconPeripheralData = self.beaconRegion.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager    = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        setLabels()
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn{
            print("Powered on")
            self.peripheralManager.startAdvertising(self.beaconPeripheralData as! [String : AnyObject])
        }
        else if peripheral.state == CBPeripheralManagerState.PoweredOff{
            print("Powered off")
            self.peripheralManager.stopAdvertising()
            
        }
    }
    
    func setLabels(){
        self.UUID.text      = "UUID:"
        self.Major.text     = "Major:"
        self.Minor.text     = "Minor:"
        self.idenitity.text = "idenitity:"

        print(self.beaconRegion.proximityUUID.UUIDString)
        self.UUID.text      = self.UUID.text! + " " + self.beaconRegion.proximityUUID.UUIDString
        if let majorText = self.beaconRegion.major?.stringValue{
            self.Major.text     = self.Major.text! + " " + majorText
            print(majorText)
        }
        if let minorText = self.beaconRegion.minor?.stringValue{
            self.Minor.text     = self.Minor.text! + " " + minorText
            print(minorText)
        }
        self.idenitity.text = self.idenitity.text! + " " + self.beaconRegion.identifier
        print(self.beaconRegion.identifier)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}