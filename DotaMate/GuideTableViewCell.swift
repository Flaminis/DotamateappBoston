//
//  GuideTableViewCell.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 11/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI


class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var guideHeroIcon: PFImageView!
    @IBOutlet weak var guideHeroNameLabel: UILabel!
    @IBOutlet weak var guideNameLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {}
}
