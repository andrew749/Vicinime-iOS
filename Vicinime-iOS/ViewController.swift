//
//  ViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate, CellDelegate {
    
    var data:[EntryModel] = [EntryModel]()
    var image:UIImage?
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register the nib for each card on the tableView
        tableView.registerNib(UINib(nibName: "Card", bundle: nil), forCellReuseIdentifier: "cardcell")
        tableView.addSubview(self.refreshControl)
        
        //add the pull to refresh indicator on the tableview
        refreshControl.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
       
        //register notficiations for statechange
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdate", name: Constants.DATA_UPDATE_NOTIFICATION(), object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate", name: Constants.LOCATION_UPDATE(), object: nil)
        
        //simple ui element to show the camera
        var b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "takeImage")
        self.navigationItem.rightBarButtonItem=b
        
        //start updating location and ask for dialog if it hasnt happened already
        LocationManager.getInstance().startLocationServices()
        
    }

    func loadData(){
        refreshControl.endRefreshing()
        if LocationManager.hasLocation{
            DataManager.getInstance().updatePosts()
        }
    }
    
    func locationUpdate(){

    }
    
    func didUpdate(){
        self.data=DataManager.getInstance().currentPosts
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        });
    }
    
    //MARK: TableView Delegate and Data source methods
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
    
    //MARK: Helper methods to upvote entries in the list
    func likeButtonClick(id:String){
        NetworkManager.getInstance().upvoteEntry(id)
    }
    func dislikeButtonClick(id:String){
        NetworkManager.getInstance().downvoteEntry(id)
    }
}

