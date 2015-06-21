//
//  ViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UpdateDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,RefreshDelegate {
    let dlManager:NetworkManager=NetworkManager()
    var data:[EntryModel]=[EntryModel]()
    let locationManager=CLLocationManager()
    var update=true
    var tempLocation:(lon:Double,lat:Double)=(lon:0,lat:0)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "Card", bundle: nil), forCellReuseIdentifier: "cardcell")
        getLocation()
        var b = UIBarButtonItem(title: "📷", style: .Plain, target: self, action:"takeImage")
        self.navigationItem.rightBarButtonItem=b
    }
    //model to do network query
    func loadData(lon:Double,lat:Double){
        dlManager.getNearbyPhotos(["lon":lon,"lat":lat], distance: 1000,delegate:self)
    }
    func refreshView(){
        loadData(tempLocation.lon, lat: tempLocation.lat)
    }
    func didUpdate(data:[EntryModel]){
        self.data=data
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CardCell=tableView.dequeueReusableCellWithIdentifier("cardcell") as! CardCell
        cell.descriptionText.text=data[indexPath.row].imageDescription
        cell.titleLabel.text=data[indexPath.row].title
        cell.mainImage.image=data[indexPath.row].image
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300;
    }
    func getLocation(){
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        if(update){
        tempLocation.lat=locValue.latitude
        tempLocation.lon=locValue.longitude
        loadData(locValue.longitude, lat: locValue.latitude)
            update=false
        }
    }
    func takeImage(){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//        imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Code here to work with media
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        var compressedData:NSData = UIImageJPEGRepresentation(chosenImage,0)
        var compressedImage:UIImage = UIImage(data: compressedData)!
        dlManager.executeUpload("iOS", description: "first image upload", loc: ["lon":tempLocation.lon,"lat":tempLocation.lat], img: EntryModel.getBase64(compressedImage),refreshDelegate:self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

