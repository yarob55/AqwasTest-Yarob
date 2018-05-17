//
//  ViewController.swift
//  AqwasTest
//
//  Created by يعرب المصطفى on 5/17/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import UIKit
import CoreLocation


//Reusable class:
/*
 setup steps:
 1-  1- go to project from project navigator > build phases > Link Binary with Libraries > + > CoreLocation.framework to be able to import it into your class
 ^^^may not be needed^^^
 
 1.1- import CoreLocation into your class
 2- info.plist > insert new row > insert: Privacy - Location When In Use Usage Description
 
 
 */
class ViewController: UIViewController
{
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        

        //locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


//the extension contains the implemented methods of the protocol
extension ViewController: CLLocationManagerDelegate
{
    //called when the location is found successfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
        } else {
            print("No coordinates")
        }
    }
    
    
    //called when there is an error in finding the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

