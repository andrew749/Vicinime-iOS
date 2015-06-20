//
//  ViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UpdateDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    let dlManager:NetworkManager=NetworkManager()
    var data:[EntryModel]=[EntryModel]()
    let locationManager=CLLocationManager()
    var update=true
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "Card", bundle: nil), forCellReuseIdentifier: "cardcell")
        getLocation()
    }
    //model to do network query
    func loadData(lon:Double,lat:Double){
        dlManager.getNearbyPhotos(["lon":lon,"lat":lat], distance: 1000,delegate:self)
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
        cell.imageView?.image=data[indexPath.row].image
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400;
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
            dlManager.executeUpload("iOS", description: "first image upload", loc: ["lon":locValue.longitude,"lat":locValue.latitude], img: EntryModel.getBase64(UIImage(named: "cat.jpg")!))
        loadData(locValue.longitude, lat: locValue.latitude)
            update=false
        }
    }
}

