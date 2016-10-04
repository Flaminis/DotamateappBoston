//
//  HeroTableViewCell.swift
//  DotaLobby
//
//  Created by Kamal Dandamudi on 5/16/16.
//  Copyright © 2016 SillyApps. All rights reserved.
//

import UIKit

class HeroChooseCVC: UICollectionViewCell {
    @IBOutlet weak var heroIconImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    var hero:Hero?
}
