//
//  AppService.swift
//  DotaMate
//
//  Created by Philip DesJean on 9/5/16.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit

class AppService: NSObject {
    
    static let sharedInstance = AppService()
    
    let api = DotaMateApi()
    
    var items = [Int:DMItems]()
    
    var heroes = [Int:DMHeroes]()
    
    func setup() {
        api.getItems()
        api.downloadHeroesFromAPI()
    }
    
    func getSearchResults(_ searchString : String, success: @escaping (_ result: [ApiUser]?) -> Void, failure: (_ result: NSError?) -> Void) {
        
        let queryParams = ["q" : searchString]

        api.getSearchResults(queryParams as [String : AnyObject]) { response, error in
            
            if error != nil {
                //explode
            }
            
            success(response)
            
        }
        
    }
    
    func getMatch(_ matchId: Int, success: @escaping (_ result: DMMatch?) -> Void, failure: (_ result: NSError?) -> Void) {
        
        api.getMatch(matchId) { response, error in
            
            if error != nil {
                //explode
            }
            
            success(response)
        }
        
    }
    
    func getPlayerProfile(_ accountId: Int, success: @escaping (_ result: DMPlayerProfile?) -> Void, failure: (_ result: NSError?) -> Void) {
        
        api.getPlayerProfile(accountId) { response, error in
            
            if error != nil {
                //explode
            }
            
            success(response)
        }
        
    }
    
    func getRecentMatches(_ accountId: Int, success: @escaping (_ result: [DMRecentMatch]?) -> Void, failure: (_ result: NSError?) -> Void) {
        api.getRecentMatches(accountId) { response, error in
            if error != nil {
                //explode
            }
            
            success(response)
        }
    }

    
    func getImage(_ url: String, imageView: UIImageView) {
        api.getImage(url, imageView: imageView)
    }

    
}
