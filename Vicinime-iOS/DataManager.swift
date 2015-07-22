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
    let networkManager=NetworkManager()
    var currentPosts:[EntryModel]=[]
    var lastRefresh=NSDate(timeIntervalSince1970: 0)
   
    class func getInstance()->DataManager{
        return DataManager.dataManager
    }
    func updatePosts(location:[String:Double]!, distance:Double){
        networkManager.getNearbyPhotos(location, distance: distance, delegate: self)
    }
    func didUpdate(data:[EntryModel]){
        self.lastRefresh = NSDate()
        currentPosts=data
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.DATA_UPDATE_NOTIFICATION(), object: nil)
    }
}