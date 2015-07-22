//
//  ViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,RefreshDelegate,CellDelegate {
    let dlManager:NetworkManager = NetworkManager()
    let dataManager = DataManager.getInstance()
    var data:[EntryModel] = [EntryModel]()
    let locationManager=CLLocationManager()
    var update=true
    var image:UIImage?
    let imagePicker = UIImagePickerController()
    var tempLocation:(lon:Double,lat:Double)=(lon:0,lat:0)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "Card", bundle: nil), forCellReuseIdentifier: "cardcell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdate", name: Constants.DATA_UPDATE_NOTIFICATION(), object: nil )
        getLocation()
        var b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "takeImage")
        self.navigationItem.rightBarButtonItem=b
    }
    //model to do network query
    func loadData(lon:Double,lat:Double){
            dataManager.updatePosts(["lon":lon,"lat":lat], distance: 1000)
    }
    func refreshView(){
        loadData(tempLocation.lon, lat: tempLocation.lat)
    }
    func didUpdate(){
        self.data=dataManager.currentPosts
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        });
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
        cell.titleLabel.text=data[indexPath.row].title
        cell.mainImage.image=data[indexPath.row].image
        cell.cellDelegate=self
        cell.cid=data[indexPath.row].id
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350;
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
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Code here to work with media
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        var compressedData:NSData = UIImageJPEGRepresentation(chosenImage,0)
        var compressedImage:UIImage = UIImage(data: compressedData)!
        self.image=compressedImage
        imagePicker.dismissViewControllerAnimated(true, completion: {
            let d=DetailsController()
            d.image=self.image!
            d.tempLocation=self.tempLocation
            d.refreshDelegate=self
            self.presentViewController(d, animated: true, completion: {
            });

        });
    }
    func likeButtonClick(id:String){
        dlManager.upvoteEntry(id)
    }
    func dislikeButtonClick(id:String){
        dlManager.downvoteEntry(id)
    }
}

