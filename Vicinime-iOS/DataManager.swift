//
//  DataManager.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-16.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class DataManager: UpdateDelegate{
    static let dataManager=DataManager()
    var currentPosts:[EntryModel]=[]
    var lastRefresh=NSDate(timeIntervalSince1970: 0)
    static var currentlyUpdating = false
    class func getInstance()->DataManager{
        return DataManager.dataManager
    }
    
    //Custom method if current location isn't the desired location
    func updatePosts(location:[String:Double]!, distance:Double){
        if !DataManager.currentlyUpdating{
            NetworkManager.getInstance().getNearbyPhotos(location, distance: distance, delegate: self)
            DataManager.currentlyUpdating = true
        }
    }
    
    func updatePosts(){
        self.updatePosts(["lon":LocationManager.getInstance().getLastLocation().lon ,"lat":LocationManager.getInstance().getLastLocation().lat], distance: 1000)
    }
    
    func didUpdate(data:[EntryModel]){
        DataManager.currentlyUpdating = false
        self.lastRefresh = NSDate()
        currentPosts=data
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.DATA_UPDATE_NOTIFICATION(), object: nil)
    }
}