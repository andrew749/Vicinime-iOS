//
//  DetailDelegate.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-21.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

protocol DetailDelegate{
    func detailsFilled(title:String,description:String)
    func cancel()
}