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

class MapViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    var image:UIImage?
    let imagePicker = UIImagePickerController()
    
    var lastLocation:CLLocation?
    
    override func viewDidLoad() {
        let initialLocation = CLLocation(latitude: 43.282778, longitude: -79.829444)
        centerMapOnLocation(initialLocation)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdate", name: Constants.DATA_UPDATE_NOTIFICATION(), object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate", name: Constants.LOCATION_UPDATE(), object: nil)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.loadLocations(DataManager.getInstance().currentPosts)
        })
        
        self.navigationItem.rightBarButtonItems=[UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "takeImage"),
                                                 UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "updatePosts")]
    }
    
    func locationUpdate(){
        if let l = lastLocation{
            let currentLocation=locationFromCoordinates(LocationManager.getInstance().getLastLocation().lon,lat:LocationManager.getInstance().getLastLocation().lat)
            if (currentLocation.distanceFromLocation(l)>20){
                centerMapOnLocation(currentLocation)
                lastLocation = currentLocation
            }
        }else{
            lastLocation = locationFromCoordinates(LocationManager.getInstance().getLastLocation().lon,lat:LocationManager.getInstance().getLastLocation().lat)
        }
    }
    
    func locationFromCoordinates(lon:Double,lat:Double)->CLLocation{
        return CLLocation(latitude: lat, longitude: lon)
    }
    func didUpdate(){
        self.loadLocations(DataManager.getInstance().currentPosts)
    }
    
    func updatePosts(){
        DataManager.getInstance().updatePosts()
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
                annotation.title="\(x.title!)"
                annotation.coordinate=CLLocationCoordinate2D(latitude: coordinate.lat, longitude:coordinate.lon)
                mapView.addAnnotation(annotation)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.reloadInputViews()
        })
    }
    //MARK: Method to launch the camera
    func takeImage(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    
    //MARK: Handle the image received from the camera
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Code here to work with media
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        var compressedData:NSData = UIImageJPEGRepresentation(chosenImage,0)
        var compressedImage:UIImage = UIImage(data: compressedData)!
        self.image=compressedImage
        imagePicker.dismissViewControllerAnimated(true, completion: {
            let d=DetailsController()
            d.image=self.image!
            d.tempLocation=LocationManager.getInstance().getLastLocation()
            self.presentViewController(d, animated: true, completion: {
            });
            
        });
    }

}