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
    convenience init(title:String,imageDescription:String,image:UIImage,location:(Double,Double)){
        self.init()
        self.title=title
        self.imageDescription=imageDescription
        self.image=image
        self.location=(lon:location.0,lat:location.1)
    }
    //for base 64 string image
    convenience init(title:String,imageDescription:String,image:String,location:(Double,Double)){
        self.init()
        self.title=title
        self.imageDescription=imageDescription
        self.image=self.imageFromB64(image)
        self.location=(lon:location.0,lat:location.1)
    }
    func imageFromB64(data:String)->UIImage?{
        var d=NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return UIImage(data: d!)
    }
    
}