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
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}