//
//  EntryModel.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-19.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
class EntryModel:NSObject{
    var title:String?
    var imageDescription:String?
    var image:UIImage?
    var location:(lon:Double,lat:Double)?
    override init(){
        super.init()
    }
    
}