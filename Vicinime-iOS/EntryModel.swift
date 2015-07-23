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
    var id:String?
    var favorites:Int=0
    var upvotes:Int=0
    
    convenience init(id:String,title:String,imageDescription:String,image:UIImage,location:(Double,Double),favorites:Int,upvotes:Int){
        self.init()
        self.id=id
        self.title=title
        self.imageDescription=imageDescription
        self.image=image
        self.location=(lon:location.0,lat:location.1)
        self.favorites=favorites
        self.upvotes=upvotes
    }
    
    //for base 64 string image
    convenience init(id:String,title:String,imageDescription:String,image:String,location:(Double,Double),favorites:Int,upvotes:Int){
        self.init()
        self.id=id
        self.title=title
        self.imageDescription=imageDescription
        self.image=self.imageFromB64(image)
        self.location=(lon:location.0,lat:location.1)
        self.favorites=favorites
        self.upvotes=upvotes
    }
    //MARK: Base64 Helper Methods
    func imageFromB64(data:String)->UIImage?{
        var d=NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return UIImage(data: d!)
    }
    
    class func getBase64(data:UIImage)->String{
        let imgData = UIImagePNGRepresentation(data)
        let string = imgData.base64EncodedStringWithOptions(.allZeros)
        return string
    }
}