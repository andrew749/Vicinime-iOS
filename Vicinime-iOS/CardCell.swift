//
//  CardCell.swift
//  Vicinime-iOS
//
//  Created by Andrew Codispoti on 2015-06-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
class CardCell: UITableViewCell{
    var cid:String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dislikeImage: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    var cellDelegate:CellDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func likeClick(sender: AnyObject) {
        if let l=cellDelegate{
            l.likeButtonClick(cid!)
        }
    }
    @IBAction func dislikeClick(sender: AnyObject) {
        if let l=cellDelegate{
            l.dislikeButtonClick(cid!)
        }
    }
}