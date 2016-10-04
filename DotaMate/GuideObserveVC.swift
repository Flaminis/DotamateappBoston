//
//  GuideObserveVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 18/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse
import Kingfisher
import SwiftSpinner


class GuideObserveVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITextViewDelegate {
    
    fileprivate let reuseIdentifier = "SpellObserveCell" //table
    fileprivate let reuseID = "ItemObserveCell" // collection
   
    @IBOutlet weak var spellRowTableView: UITableView!
    
    @IBOutlet weak var itemProgressionCollectionView: UICollectionView!
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var guideDescriptionTV: UITextView!
    
    @IBOutlet weak var heroNameLabel: UILabel!
    
    var guideShown: Guide?
    var backGroundImageProsto: UIImage?
    
    var spellsFromParse = ""
    var SpellArray = [String]()
    var itemsFromParse = ""
    var itemArray = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGray
        
        heroNameLabel.text = guideShown?.heroGuidePosition
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if guideShown != nil {
            
            backGroundImageView.image = backGroundImageProsto
       
            self.spellsFromParse = (guideShown?.skillBuild)!
            self.SpellArray = self.spellsFromParse.characters.split{$0 == "+"}.map(String.init)
            self.itemsFromParse = (guideShown?.items)!
            self.itemArray = self.itemsFromParse.characters.split{$0 == "+"}.map(String.init)
           
            itemProgressionCollectionView.reloadData()
            spellRowTableView.reloadData()
            SwiftSpinner.hide()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Guide")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build()! as! [AnyHashable : Any])
    }
    
    override func viewDidLayoutSubviews() {
        //
        //This can be refactored leaving for now
        //
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = itemProgressionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let bounds = itemProgressionCollectionView.bounds
        let ratio: CGFloat = 0.46
        let width: CGFloat = bounds.width / 3 - flowLayout.minimumInteritemSpacing * 2
        let height = width * ratio + 20
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        incrementVoteCount()
        guideDescriptionTV.text = guideShown?.guideDescription
        self.guideDescriptionTV.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
    }
    
    
    func incrementVoteCount() {
        guideShown?.guideNumOfViews += 1
        guideShown?.saveInBackground()
    }
    
    ///////
    //MARK: TableViewDelegates
    ///////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! GuideObserveSpellTVC
        
        cell.spellHeroLevel.text = String((indexPath as NSIndexPath).row+1)
        
        let spellImageUrl = URL(string:"http://media.steampowered.com/apps/dota2/images/abilities/\(SpellArray[(indexPath as NSIndexPath).row])_hp2.png")
        cell.spellPicture.kf.setImage(with:spellImageUrl!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //MARK: CVC init
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    
    //cell config
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (reuseID), for: indexPath) as! GuideObserveItemCVC
        
        let item = itemArray[(indexPath as NSIndexPath).row]
    
        cell.itemIcon.kf.setImage(with:URL(string: item)!)
        cell.layoutSubviews()
        
        return cell
    }
}
