//
//  NetworkManager.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-19.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class NetworkManager{
    let postUrl="http://192.168.1.10:3000/upload"
    let getUrl="http://192.168.1.10:3000/near"
    let upvoteEndpoint="http://192.168.1.10/upvote/"
    let downvoteEndpoint="http://192.168.1.10/downvote/"
    let favoriteEndpoint="http://192.168.1.10/favorite/"
    func executeUpload(title:String,description:String,loc:[String:Double],img:String,refreshDelegate:RefreshDelegate){
        self.post(["title":title,"description":description,"loc":["lon":loc["lon"]!,"lat":loc["lat"]!] ,"img":["data":img,"contentType":"media/jpeg"]], url: postUrl,delegate: nil,refreshDelegate:refreshDelegate)
    }
    //gonna differentiate b/w getting data and putting data with prescence of delegate
    func post(params : Dictionary<String, AnyObject!>, url : String, delegate:UpdateDelegate?, refreshDelegate:RefreshDelegate?) {
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
            if let d=delegate{
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSArray
                
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
                        println("Success")
                        var temp:[EntryModel]=[EntryModel]()
                        for x in parseJSON{
                            temp.append(EntryModel(id:x["_id"] as! String,title: x["title"] as! String, imageDescription: x["description"] as! String, image: (x["img"] as! NSDictionary)["data"] as! String, location: (((x["loc"] as! NSDictionary)["coordinates"] as! NSArray)[0] as! Double,((x["loc"] as! NSDictionary)["coordinates"] as! NSArray)[1] as! Double),favorites:(x["meta"] as!NSDictionary)["votes"] as! Int,upvotes:(x["meta"] as!NSDictionary)["favs"] as! Int))
                        }
                        d.didUpdate(temp)
                        return ;
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            }else{
                refreshDelegate?.refreshView()
            }
        })
        
        task.resume()
    }
    func getNearbyPhotos(loc:[String:Double],distance:Double,delegate:UpdateDelegate){
        post(["lon":loc["lon"],"lat":loc["lat"],"distance":distance], url: getUrl,delegate:delegate,refreshDelegate:nil)
    }
    func upvoteEntry(id:String){
        let url=NSURL(string: "\(upvoteEndpoint)\(id)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
        }
    }
    func downvoteEntry(id:String){
        let url=NSURL(string: "\(downvoteEndpoint)\(id)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
        }
    }
    func favoriteEntry(id:String){
        let url=NSURL(string: "\(favoriteEndpoint)\(id)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    }
}