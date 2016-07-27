//
//  ViewController.swift
//  MyBeacon
//
//  Created by Shawn on 2016-01-27.
//  Copyright © 2016 Shawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    
    var textField           = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let trackButton             = UIButton()
        trackButton.frame.size      = CGSize(width: 200, height: 50)
        trackButton.frame.origin    = CGPoint(x: (screenSize.width - 200)/2, y: 100)
        trackButton.backgroundColor = UIColor.whiteColor()
        trackButton.setTitle("Track Beacon", forState: .Normal)
        trackButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        trackButton.addTarget(self, action: "goToTrack", forControlEvents: .TouchUpInside)
        
        
        let transmitButton              = UIButton()
        transmitButton.frame.size       = CGSize(width: 200, height: 50)
        transmitButton.frame.origin     = CGPoint(x: (screenSize.width - 200)/2, y: 150)
        transmitButton.backgroundColor  = UIColor.whiteColor()
        transmitButton.setTitle("Transmit Beacon", forState: .Normal)
        transmitButton.setTitleColor(.blueColor(), forState: .Normal)
        transmitButton.addTarget(self, action: "goToConfig", forControlEvents: .TouchUpInside)
        
        textField.frame.size    = CGSize(width: 300, height: 50)
        textField.frame.origin  = CGPoint(x: screenSize.width/2 - 150.0, y: 200)
        textField.borderStyle   = UITextBorderStyle.RoundedRect
        textField.returnKeyType = .Done
        textField.delegate      = self
        textField.placeholder   = "206A2476-D4DB-42F0-BF73-030236F2C756"
        
        
        self.view.addSubview(trackButton)
        self.view.addSubview(transmitButton)
        self.view.addSubview(textField)
        
    }
    
    func goToTrack(){
        let TVC = TrackViewController()
        self.navigationController?.pushViewController(TVC, animated: true)
    }
    
    func goToConfig(){
        let CVC = ConfigViewController()
        self.navigationController?.pushViewController(CVC, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newUUID : NSUUID = NSUUID(UUIDString: textField.text!){
            let TVC     = TrackViewController()
            let CVC     = ConfigViewController()
            TVC.initRegion()
            CVC.initBeacon()
            TVC.setLabelText()
            CVC.setLabels()
            print(TVC.uuidT)
            print(CVC.uuidT)
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

