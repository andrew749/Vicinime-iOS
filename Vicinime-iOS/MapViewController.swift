//
//  MapViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-16.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController:UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func loadLocations(entryModels:[EntryModel]){
        for x in entryModels{
            if let coordinate=x.location{
                let annotation=MKPointAnnotation()
                annotation.title="\(x.title)"
                annotation.coordinate=CLLocationCoordinate2D(latitude: coordinate.lat, longitude:coordinate.lon)
                mapView.addAnnotation(annotation)
            }
        }
        mapView.reloadInputViews()
    }
}