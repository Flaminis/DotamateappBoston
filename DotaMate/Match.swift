//
//  Match.swift
//  DotaMate
//
//  Created by Philip DesJean on 9/11/16.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import SwiftyJSON

class Match: NSObject {

    var matchId : Int?
    var cluster : String?
    var replaySalt : String?
    var seriesId : Int?
    var parties : [String:Int]?
    var skill : Int?
    var players : [Player]?
    
    
    init(json: JSON) {
        
    }
    
}
