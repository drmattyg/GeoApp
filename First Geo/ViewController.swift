//
//  ViewController.swift
//  First Geo
//
//  Created by Matthew Gordon on 7/20/15.
//  Copyright (c) 2015 Dr Matty G. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let motionManager = CMMotionActivityManager()
    
    let formatter : NSNumberFormatter =  {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 5
        return formatter
    }()

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var motionLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        label.text = "Waiting for location..."
        startLocating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let motionHandler : CMMotionActivityHandler = { (data) in
        dispatch_async(dispatch_get_main_queue()) {
        }
    }
    
    func startLocating() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        motionManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data : CMMotionActivity!) -> Void in
            var indicatorText = ":"
            if(data.stationary) {
                indicatorText += "S"
            }
            if(data.walking) {
                indicatorText += "W"
            }
            if(data.running) {
                indicatorText += "R"
            }
            if(data.cycling) {
                indicatorText += "B"
            }
            if(data.automotive) {
                indicatorText += "C"
            }
            
            self.motionLabel.text = indicatorText + ":"
        })
    }
    


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]!) {
        println("Got new location data")
        var locationArray = locations! as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var lat = locationObj.coordinate.latitude
        var lon = locationObj.coordinate.longitude
        var speed = locationObj.speed
        var locationString = "\(lat),\(lon)"
        label.text = locationString
        
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location manager reported failure")
    }

}

