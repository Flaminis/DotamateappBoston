//
//  GuideFeedViewController.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 11/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse

class GuideFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var feed = [Guide]()
    var guideIds = [String]()


    @IBOutlet weak var guideTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guideTableView.dataSource = self
        guideTableView.delegate = self
        guideTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        guideTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        
        
        
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func getObjectIdsForGuides () {
        
        var objectIds = [String]()
        
        let query = PFQuery(className:"Guide")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        objectIds.append(String(object.valueForKey("objectId")!))
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            print(objectIds)
            self.guideIds = objectIds
        }
        
    }
    
//    
//       func findAsyncAllPosts() {
//    
//    var count = 0
//    var query = PFQuery(className:"Guide")
////         query.getObjectInBackgroundWithId("xWMyZEGZ") {
////    (singleGuide: PFObject?, error: NSError?) -> Void in
//    if error == nil && singleGuide != nil {
//    
//   // self.feed[count].dateCreated = singleGuide!.createdAt
//    self.feed[count].guideDescription = singleGuide!["guideDescription"] as? String
//    self.feed[count].guideName = singleGuide!["guideName"] as? String
//    self.feed[count].likes = singleGuide!["likeNum"] as? Int
//    self.feed[count].hero = singleGuide!["hero"] as? PFRelation
//
//        
//        
////        let score = gameScore["score"] as Int
////        let playerName = gameScore["playerName"] as String
////        let cheatMode = gameScore["cheatMode"] as Bool
//    } else {
//    print(error)
//    }
//    }

    
    
//    }
    
    
    
    
    
    
    
    
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = guideTableView.dequeueReusableCellWithIdentifier("GuideCell", forIndexPath: indexPath) as! ArticleTableViewCell
//        
//        let guide = data[indexPath.row]
//        
//        cell.avatarImage.image = UIImage(named: article.avatarImage)
//        cell.articleCoverImage.image = UIImage(named: article.articleCoverImage)
//        cell.sharedNameLabel.text = article.sharedName
//        cell.actionTypeLabel.text = article.actionType
//        cell.articleTitleLabel.text = article.articleTitle
//        cell.articleSouceLabel.text = article.articleSouce
//        cell.articelCreatedAtLabel.text = article.articleTime
        
      //  cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }

    
    
    
}
