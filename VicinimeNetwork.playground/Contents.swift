//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let posturl="http://localhost:3000/upload"
let getUrl="http://localhost:3000/near"
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
    func imageFromB64(data:String)->UIImage{
        var d=NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return UIImage(data: d!)!
    }
    
}

func post(params : Dictionary<String, AnyObject!>, url : String) {
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    var session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        println("Response: \(response)")
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        if(err != nil) {
            println(err!.localizedDescription)
            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//                var success = parseJSON[0] as? Int
//                println("Succes: \(success)")
                var temp:[EntryModel]
               let x=json![0]
                println(x)
                x["title"]
                x["description"]
                (x["img"] as! NSDictionary)["data"]
               ((x["loc"] as! NSDictionary)["coordinates"] as! NSArray)[0]
                x["_id"]
            }
            else {
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: \(jsonStr)")
            }
        }
    })
    
    task.resume()
}
func getBase64(data:UIImage)->String{
    let imgData = UIImagePNGRepresentation(data)
    let string = imgData.base64EncodedStringWithOptions(.allZeros)
    return string
}

//
//post(["title":"pic","description":"hello world","loc":["lon":45,"lat":-45] ,"img":["data":"test","contentType":"media/jpeg"]], posturl)
post(["lon":-79.58791891120336,"lat":43.79951570652779,"distance":1000000],getUrl)

XCPSetExecutionShouldContinueIndefinitely()
