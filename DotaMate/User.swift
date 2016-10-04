//
//  User.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 22/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    private static var __once: () = {
//            self.registerSubclass()
        }()
    
    @NSManaged var avatar: PFFile
    @NSManaged var SteamID: String
    @NSManaged var upvotes: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken: Int = 0
        }
        
        _ = User.__once
    }
}
