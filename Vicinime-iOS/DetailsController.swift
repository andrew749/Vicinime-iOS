//
//  DetailsController.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-21.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
class DetailsController:UIViewController,DetailDelegate{
    var image:UIImage?
    var tempLocation:(lon:Double,lat:Double)?
    var refreshDelegate:RefreshDelegate?
    let dlManager:NetworkManager=NetworkManager()
    var detailView:DetailsView?
    func detailsFilled(title:String,description:String){
        dlManager.executeUpload(title, description: description, loc: ["lon":tempLocation!.lon,"lat":tempLocation!.lat], img: EntryModel.getBase64(image!),refreshDelegate:refreshDelegate!)
        cancel()
    }
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        self.view.frame=CGRect(x: 0, y: 0, width: 300, height: 400)
        detailView=NSBundle.mainBundle().loadNibNamed("DetailsView", owner: self, options: nil)[0] as? DetailsView
        detailView!.detailDelegate=self
        self.view.addSubview(detailView!)
    }
}