//
//  DataManager.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-16.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class DataManager{
    static var manager=DataManager()
    var currentPosts=[]
    var lastRefresh=NSDate(timeIntervalSince1970: 0)
    func updatePosts(location:[AnyObject]!){
        
    }
}