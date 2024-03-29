//
//  HeroDetail.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 13/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.

import Foundation

class HeroDetail{
    
    var hero:Hero
    var primaryAttribute:PrimaryAttribute
    var roles:[String]
    var attackType:AttackType
    var baseStrength:Double
    var baseAgility:Double
    var baseIntelligence:Double
    var strengthIncrease:Double
    var agilityIncrease:Double
    var intelligenceIncrease:Double
    var movementSpeed:Double
    var turnRate:Double
    var sightRangeDay:Double
    var sightRangeNight:Double
    var attackRange:Double
    var baseArmor:Double
    var baseAttackLow:Double
    var baseAttackHigh:Double
    var abilities:[Ability]
    
    init(hero:Hero,primaryAttribute:PrimaryAttribute,roles:[String], attackType:AttackType,baseStrength:Double,baseAgility:Double,baseIntelligence:Double,strengthIncrease:Double,agilityIncrease:Double,intelligenceIncrease:Double,movementSpeed:Double,turnRate:Double,sightRangeDay:Double,sightRangeNight:Double,attackRange:Double,baseArmor:Double,baseAttackLow:Double,baseAttackHigh:Double,abilities:[Ability]){
        self.hero = hero
        self.primaryAttribute = primaryAttribute
        self.roles = roles
        self.attackType = attackType
        self.baseStrength = baseStrength
        self.baseAgility = baseAgility
        self.baseIntelligence = baseIntelligence
        self.strengthIncrease = strengthIncrease
        self.agilityIncrease = agilityIncrease
        self.intelligenceIncrease = intelligenceIncrease
        self.movementSpeed = movementSpeed
        self.turnRate = turnRate
        self.sightRangeDay = sightRangeDay
        self.sightRangeNight = sightRangeNight
        self.attackRange = attackRange
        self.baseArmor = baseArmor
        self.baseAttackLow = baseAttackLow
        self.baseAttackHigh = baseAttackHigh
        self.abilities = abilities
    }
}

class Ability{
    var name:String
    var description:String
    var dotaName:String
    var urlSmall:String
    var urlLarge:String
    
    init(name:String,description:String,dotaName:String,urlSmall:String,urlLarge:String){
        self.name = name
        self.description = description
        self.dotaName = dotaName
        self.urlLarge = urlLarge
        self.urlSmall = urlSmall
    }
}

enum PrimaryAttribute{
    case strength
    case agility
    case intelligence
}

enum AttackType{
    case ranged
    case melee
}
