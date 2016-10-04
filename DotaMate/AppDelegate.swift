//
//  AppDelegate.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 07/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
//import Parse-iOS-SDK
import Parse
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        Parse.enableLocalDatastore()
        
        Parse.initialize( with: ParseClientConfiguration { (config: ParseMutableClientConfiguration) -> Void in
            config.applicationId = ParseSettings.applicationId
            config.clientKey = ParseSettings.clientKey
            config.server = ParseSettings.server
        })
        
        User.registerSubclass()
        Guide.registerSubclass()
        Like.registerSubclass()
        
        registerClasses()
        login()
        
        AppService.sharedInstance.setup()
        
        return true
    }
    
    func registerClasses(){
        User.registerSubclass()
        Guide.registerSubclass()
    }
    
    func login() {
        if let user = User.current() {
            print("\(#function) -> \(user.username)")
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as!UITabBarController
            window?.rootViewController = myTabBar
        }
    }
}

