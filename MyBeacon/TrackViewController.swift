//
//  TrackViewController.swift
//  MyBeacon
//
//  Created by Shawn on 2016-01-27.
//  Copyright © 2016 Shawn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

class TrackViewController: UIViewController, CLLocationManagerDelegate {
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var iBeacon    = UILabel()
    var UUID       = UILabel()
    var Major      = UILabel()
    var Minor      = UILabel()
    var Accouracy  = UILabel()
    var Distance   = UILabel()
    var RSSI       = UILabel()
    var uuidT      = "206A2476-D4DB-42F0-BF73-030236F2C756"
    
    var beaconRegion = CLBeaconRegion()
    var trackLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iBeacon.frame.size      = CGSize(width: 200, height: 50)
        iBeacon.frame.origin    = CGPoint(x: screenSize.width/2 - 100, y: 50)
        iBeacon.numberOfLines   = 0
        iBeacon.lineBreakMode   = NSLineBreakMode.ByWordWrapping
        
        
        UUID.frame.size         = CGSize(width: 200, height: 50)
        UUID.frame.origin       = CGPoint(x: screenSize.width/2 - 100, y: 100)
        
        
        Major.frame.size        = CGSize(width: 200, height: 50)
        Major.frame.origin      = CGPoint(x: screenSize.width/2 - 100, y: 150)
        
        
        Minor.frame.size        = CGSize(width: 200, height: 50)
        Minor.frame.origin      = CGPoint(x: screenSize.width/2 - 100, y: 200)
        
        
        RSSI.frame.size         = CGSize(width: 200, height: 50)
        RSSI.frame.origin       = CGPoint(x: screenSize.width/2 - 100, y: 250)
        
        
        Distance.frame.size     = CGSize(width: 200, height: 50)
        Distance.frame.origin   = CGPoint(x: screenSize.width/2 - 100, y: 300)
        Distance.numberOfLines  = 0
        Distance.lineBreakMode  = NSLineBreakMode.ByWordWrapping
        Distance.font           = UIFont(name: (Distance.font?.fontName)!, size: 10)
        
        
        Accouracy.frame.size    = CGSize(width: 400, height: 50)
        Accouracy.frame.origin  = CGPoint(x: screenSize.width/2 - 100, y: 350)
        Accouracy.numberOfLines = 0
        Accouracy.lineBreakMode = NSLineBreakMode.ByWordWrapping
        Accouracy.font          = UIFont(name: (Accouracy.font?.fontName)!, size: 10)
        
        setLabelText()
        
        self.view.addSubview(iBeacon)
        self.view.addSubview(UUID)
        self.view.addSubview(Major)
        self.view.addSubview(Minor)
        self.view.addSubview(Accouracy)
        self.view.addSubview(Distance)
        self.view.addSubview(RSSI)
        
        if #available(iOS 8.0, *) {
            trackLocationManager.requestAlwaysAuthorization()
            print("8.0")
        } else {
            // Fallback on earlier versions
        }
        
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            trackLocationManager.startUpdatingLocation()
//            print("")
//        }

        
        self.view.backgroundColor = UIColor.whiteColor()
        self.trackLocationManager = CLLocationManager()
        self.trackLocationManager.delegate = self
        print("1")
        self.initRegion()
        print("2")
        self.locationManager(self.trackLocationManager, didStartMonitoringForRegion: self.beaconRegion)
    }
    
    func setLabelText(){
        iBeacon.text   = "进入iBeacon:"
        UUID.text      = "UUID:"
        Major.text     = "Major:"
        Minor.text     = "Minor:"
        Accouracy.text = "Accouracy:"
        Distance.text  = "Distance:"
        RSSI.text      = "RSSI:"
    }
    
    func initRegion(){
        var uuid = NSUUID(UUIDString: uuidT)
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.MyBeacon.Region")
        self.trackLocationManager.startMonitoringForRegion(self.beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.trackLocationManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        self.trackLocationManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        self.trackLocationManager.stopRangingBeaconsInRegion(self.beaconRegion)
        self.iBeacon.text = self.iBeacon.text! + " " + "No"
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("beacons count" + String(beacons.count))
        if beacons.count == 0{
            return
        }
        var beacon: AnyObject = beacons[beacons.count - 1]
        self.iBeacon.text     = self.iBeacon.text! + " " + "Yes"
        
        self.UUID.text        = self.UUID.text! + " " + beacon.proximityUUID.UUIDString
        
        if let majorText   = beaconRegion.major?.stringValue{
            self.Major.text   = self.Major.text! + " " + majorText
        }
        if let minorText   = beacon.minor?!.stringValue{
            self.Minor.text   = self.Minor.text! + " " + minorText
        }
        if let accText     = beacon.accuracy {
            self.Accouracy.text = self.Accouracy.text! + " " + String(accText)
        }
        
        if (beacon.proximity != nil) {
            switch(beacon.proximity!){
            case .Unknown:
                self.Distance.text = self.Distance.text! + " " + "Unknow proximity"
            case CLProximity.Immediate:
                self.Distance.text = self.Distance.text! + " " + "Immediate"
            case CLProximity.Near:
                self.Distance.text = self.Distance.text! + " " + "Near"
            case CLProximity.Far:
                self.Distance.text = self.Distance.text! + " " + "Far"
            default:
                print("default of switch-case")
            }
        }
        self.RSSI.text = self.RSSI.text! + " " + beacon.rssi!.description
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
