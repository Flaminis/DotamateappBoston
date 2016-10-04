//
//  Guide.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 11/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import Foundation
import Parse

struct Hero {
    var heroDotaName:String!
    var heroLocalizedName:String!
    var heroID:Int!
    var largeImageURL:String?
    var smallImageURL:String?
    var portraitImageURL:String?
    var heroSoundURL:String = ""
}

extension Hero {
    
    init(heroDotaName:String, heroLocalizedName:String, heroID:Int? = nil,largeImageURL:String,smallImageURL:String,portraitImageURL:String){
        self.heroDotaName = heroDotaName
        self.heroLocalizedName = heroLocalizedName
        self.heroID = heroID
        self.largeImageURL = largeImageURL
        self.smallImageURL = smallImageURL
        self.portraitImageURL = portraitImageURL
    }
}
