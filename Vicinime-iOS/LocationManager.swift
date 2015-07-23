//
//  LocationManager.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-22.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager:NSObject,CLLocationManagerDelegate{
    static var locationManager:LocationManager = LocationManager()
    var clLocationManager = CLLocationManager()
    var lastLocation:(lon:Double,lat:Double)=(lon:0,lat:0)
    
    static var hasLocation = false
    
    class func getInstance()->LocationManager{
        return LocationManager.locationManager
    }
    override init(){
        super.init()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationServices(){
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        LocationManager.hasLocation = true
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        lastLocation.lat=locValue.latitude
        lastLocation.lon=locValue.longitude
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.LOCATION_UPDATE(), object: nil)
    }
    
    func getLastLocation()->(lon:Double,lat:Double){
        return lastLocation
    }
}
