//
//  RestaurantService.swift
//  AqwasTest
//
//  Created by يعرب المصطفى on 5/17/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class RestaurantService
{
    class func getRestaurant(latitude: Double, longitude: Double, radius: Double, completion: @escaping (_ error: Error?, _ restaurant:Restaurant?)->Void)
    {
        
        let fullUrl = "\(Url.baseUrl)?lat=\(String(latitude))&lon=\(String(longitude))&p=i&lang=ar&distance=\(radius)"
        let url = URL(string: "\(fullUrl)")
        
        //request's headers
        let headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        //the main request
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<400).responseJSON { (response) in
            switch response.result
            {
                //success case.......
                case .success(let val):
                    let json = JSON(val)
                    var restaurant = Restaurant()
                    restaurant.name = json["name"].string
                    restaurant.rate = json["rate"].double
                    restaurant.cateName = json["cateName"].string
                    
                    
                    print("restaurant from the service",json)
                    //let user = post.1["user"]
                    completion(nil, restaurant)
                
                //failure case.......
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
}
