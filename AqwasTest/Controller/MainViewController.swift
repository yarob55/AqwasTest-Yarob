//
//  MainViewController.swift
//  AqwasTest
//
//  Created by يعرب المصطفى on 5/17/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var rangeSlider: UISlider!
    var myLocation:Location?
    let locationManager = CLLocationManager()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Do any additional setup after loading the view.
    }
    
    //this function is used to check if the location permession is given to the app
    private func checkLocationAuth()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func suggestButtonClicked(_ sender: UIButton)
    {
        //locationManager.requestLocation()
        RestaurantService.getRestaurant(latitude: 37.36424153, longitude: -122.12374717, radius: Double(5000))
        { (err, restaurant) in
            if let err = err
            {
                print("Error:",err)
            }else
            {
                print(restaurant,"from the vc :)")
            }
        }
    }
    
    
    private func getRestaurant()
    {
        let range = rangeSlider.value
        //if the location is set and the request location is done..
        if let location = myLocation
        {
            RestaurantService.getRestaurant(latitude: location.lat, longitude: location.long, radius: Double(range))
                { (err, restaurant) in
                    if let err = err
                    {
                        print("Error:",err)
                    }else
                    {
                        print(restaurant,"from the vc :)")
                    }
                }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: CLLocationManagerDelegate
{
    //called when the location is found successfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude
        {
            myLocation = Location(long: long, lat: lat)
            print("\(lat),\(long)", "from delegated method")
            self.getRestaurant()
        }
        else
        {
            print("No coordinates")
        }
    }
    
    
    //called when there is an error in finding the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
