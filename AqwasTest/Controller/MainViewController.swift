//
//  MainViewController.swift
//  AqwasTest
//
//  Created by يعرب المصطفى on 5/17/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import Spring
import GoogleMaps
import GooglePlaces

class MainViewController: UIViewController {

    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var rangeSlider: UISlider!
    var myLocation:Location?
    let locationManager = CLLocationManager()
    var marker:GMSMarker?
    var viewIsIn = false //this var is used to check if the info view in the screen or outside it in order to know the needed animation at that time
    
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    
    @IBOutlet weak var restaurantView: SpringView!
    
    @IBOutlet weak var restInfoBgView: SpringView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        checkLocationAuth()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        restaurantView.transform = CGAffineTransform(translationX: 2000, y: 0)
        restInfoBgView.transform = CGAffineTransform(translationX: 0, y: -2000)
        restInfoBgView.isHidden  = true
        loadMap()//to set the camera of the map

        // Do any additional setup after loading the view.
    }
    
    
    //this function is used to check if the location permession is given to the app
    private func checkLocationAuth()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                MessageDialog.showMessage(title: "خطأ", message: "الرجاء السماح للتطبيق بالدخول لموقعك", vc: self)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            MessageDialog.showMessage(title: "خطأ", message: "الرجاء السماح للتطبيق بالدخول لموقعك", vc: self)
        }
    }

    
    @IBAction func suggestButtonClicked(_ sender: UIButton)
    {
        locationManager.requestLocation()
        indicator.startAnimating()
    }
    
    
    //the main request to the service is here
    private func getRestaurant()
    {
        let range = rangeSlider.value
        //if the location is set and the request location is done..
        if let location = myLocation
        {
            RestaurantService.getRestaurant(latitude: location.lat, longitude: location.long, radius:10000)
                { (err, restaurant) in
                    self.indicator.stopAnimating()
                    if let err = err
                    {
                        print("Error:",err)
                        MessageDialog.showMessage(title: "خطأ", message:err.localizedDescription, vc: self)
                    }else
                    {
                        self.animateView(restaurant: restaurant!)
                        self.loadMap()
                        print(restaurant,"from the vc :)")
                    }
                }
        }else
        {
            MessageDialog.showMessage(title: "خطأ", message: "الرجاء السماح للتطبيق بتحديد الموقع", vc: self)
        }
    }
    
    
    //for animating the information of the new suggested restaurant into the scene
    private func animateView(restaurant:Restaurant)
    {
        //if the view of restaurant content is loaded
        if viewIsIn
        {
            restaurantView.animation = "squeezeRight"
            //restaurantView.x = -1000
            restaurantView.animateToNext
                {
                    self.restaurantNameLabel.text = restaurant.name
                    self.restaurantTypeLabel.text = restaurant.cateName
                    self.restaurantView.animation = "squeezeLeft"
                    self.restaurantView.animate()
                }
        }else
        {
            viewIsIn = true
            restInfoBgView.animation = "fadeInDown"
            restInfoBgView.isHidden = false
            restInfoBgView.duration = 1.2
            restInfoBgView.curve = "linear"
            restInfoBgView.animateNext
            {
                self.restaurantView.animation = "squeezeLeft"
                self.restaurantView.animate()
            }
            
        }
    }
    
    
    ////////////////////MAPS CODE//////////////
    func loadMap()
    {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        var lat = 26.313002
        var long = 50.149680
        
        if let latitude = myLocation?.lat, let longitude = myLocation?.long
        {
            lat = latitude
            long = longitude
            removeAllMarkers()
            createMarker(lat: latitude, long: longitude, color: Colors.mainColor)
            
        }
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.animate(to: camera)
        
        
    }
    
    
    func createMarker(lat:Double, long:Double, color:UIColor)
    {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.icon = GMSMarker.markerImage(with: color)
        //marker.icon = GMSMarker.markerImage(with: color)
        marker.map = map
    }
    
    func removeAllMarkers()
    {
        map.clear()
    }

}


/////////////////LOCATION MANAGER DELEGATE/////////////////
extension MainViewController: CLLocationManagerDelegate
{
    //called when the location is found successfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude
        {
            myLocation = Location(long: long, lat: lat)
            print("\(lat),\(long)", "from delegated method")
            //if the location is successfully determined, then suggest a restaurant to the user
            self.getRestaurant()
        }
        else
        {
            print("No coordinates")
            MessageDialog.showMessage(title: "خطأ", message: "لم يتم تحديد الموقع", vc: self)
        }
    }
    
    
    //called when there is an error in finding the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        MessageDialog.showMessage(title: "خطأ", message: error.localizedDescription, vc: self)
    }
}







