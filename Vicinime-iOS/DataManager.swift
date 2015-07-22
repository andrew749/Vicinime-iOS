//
//  DataManager.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-16.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class DataManager: UpdateDelegate{
    static var manager=DataManager()
    let networkManager=NetworkManager()
    var currentPosts=[]
    var lastRefresh=NSDate(timeIntervalSince1970: 0)
    func updatePosts(location:[String:Double]!, distance:Double){
        networkManager.getNearbyPhotos(location, distance: distance, delegate: self)
    }
    func didUpdate(data:[EntryModel]){
        currentPosts=data
    }
}