//
//  Item.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 14/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import Foundation

class Item {
    var name:String!
    var itemLocalizedName:String!
    var quality: String!
    var itemId:Int!
    var itemImageURL:String?
    var cost: Int?
    var description: String?
    var notes: String?
    var lore: String?
   
    init(name:String,itemLocalizedName:String, quality:String,itemId:Int,itemImageURL:String,cost: Int, description:String,notes:String,lore:String){
        self.name = name
        self.itemLocalizedName=itemLocalizedName
        self.quality=quality
        self.itemId=itemId
        self.itemImageURL=itemImageURL
        self.cost=cost
        self.description=description
        self.notes=notes
        self.lore=lore
    }
}