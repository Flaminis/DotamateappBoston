//
//  TabBarVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 18/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.toolbarItems
        for item in self.tabBar.items!{
            item.titlePositionAdjustment.vertical=10.0
        }
        // Do any additional setup after loading the view.
    }

}
