//
//  headerForProfileVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 12/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit

class headerForProfileV: UICollectionReusableView {
        
    @IBOutlet weak var numberOfUpVotesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backGroundImageHeader: UIImageView!
    
    @IBAction func editProfileBtn(_ sender: UIButton) {}
    
    @IBAction func logout(_ sender: UIButton) {
        User.logOut()
    }
}
