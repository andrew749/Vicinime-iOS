//
//  DetailsView.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-21.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
class DetailsView: UIView{
    var detailDelegate:DetailDelegate?
    @IBOutlet weak var descriptionText: UITextView!
    @IBAction func doneClick(sender: AnyObject) {
        if let l=detailDelegate{
            l.detailsFilled(titleText.text, description: descriptionText.text)
        }
    }
    @IBOutlet weak var titleText: UITextField!
}