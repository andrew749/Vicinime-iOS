//
//  ViewController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UpdateDelegate,UIImagePickerControllerDelegate {
    let dlManager:NetworkManager=NetworkManager()
    var data:[EntryModel]=[EntryModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "Card", bundle: nil), forCellReuseIdentifier: "cardcell")
        loadData()
//        dlManager.executeUpload("iOS", description: "first image upload", loc: [46,-46], img: EntryModel.getBase64(UIImage(named: "cat.jpg")!))
    }
    //model to do network query
    func loadData(){
        dlManager.getNearbyPhotos(["lon":46,"lat":-46], distance: 10,delegate:self)
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
}

