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
    let dlManager:NetworkManager=NetworkManager()
    func detailsFilled(title:String,description:String){
        dlManager.executeUpload(title, description: description, loc: ["lon":tempLocation!.lon,"lat":tempLocation!.lat], img: EntryModel.getBase64(image!), refreshDelegate:nil)
        cancel()
    }
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func loadView() {
        self.view=NSBundle.mainBundle().loadNibNamed("DetailsView", owner: self, options: nil)[0] as? DetailsView
    }
    override func viewDidLoad() {
        (self.view as? DetailsView)?.detailDelegate=self
    }
}