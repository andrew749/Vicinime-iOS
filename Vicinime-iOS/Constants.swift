//
//  Constants.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-07-17.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class Constants{
    class func baseURL()->String{
        return "http://192.168.1.15:3000/"
    }
    class func postURL()->String{
        return "\(baseURL())upload"
    }
    class func getURL()->String{
        return "\(baseURL())near"
    }
    class func upvoteEndpoint()->String{
        return "\(baseURL())upvote/"
    }
    class func downvoteEndpoint()->String{
        return "\(baseURL())downvote/"
    }
    class func favoriteEndpoint()->String{
        return "\(baseURL())favorite/"
    }
}