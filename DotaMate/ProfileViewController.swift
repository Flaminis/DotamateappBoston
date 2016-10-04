
//
//  profileVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 12/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse
import NSDate_TimeAgo
import SCLAlertView
import Kingfisher

private let reuseIdentifier = "Cell"

class profileVC: UICollectionViewController {
    
    var refresher : UIRefreshControl!
    
    var guideList:[Guide] = []
    var guideSkip = 0
    var upvotes = 0
    var isLoading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AppService.sharedInstance.getSearchResults("Graphs", success: { (result) in
            
        }) { (result) in
            
        }

        collectionView?.backgroundColor = UIColor.white
        
        //title on top
        self.navigationItem.title = "DotaMate"//PFUser.currentUser()?.username?.uppercaseString
        
        loadGuides()
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "unliked"), object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let bounds = self.view.bounds
        let ratio: CGFloat = 0.5
        let width: CGFloat = bounds.width  - flowLayout.minimumInteritemSpacing*0
        let height = width * ratio
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker?.set(kGAIScreenName, value: "Feed")
        
    }
    
    //refresh on pull
    func refresh() {
        loadGuides()
        refresher.endRefreshing()
    }
    
    func loadGuides() {
        Guide.fetchGuides(0, limit: 10) { (guides, error) in
            
            guard let guides = guides else {return}
            self.guideList.removeAll(keepingCapacity: false)
            self.guideList = guides
            self.collectionView?.reloadData()
        }
    }
    
    func loadMoreGuides() {
        
        if isLoading {
            return
        }
        
        isLoading = true
        Guide.fetchGuides(guideList.count, limit: 10) { (guides, error) in
            guard let guides = guides else {return}
            self.guideList += guides
            self.collectionView?.reloadData()
            self.isLoading = false
        }
        
    }
   
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)  as! headerForProfileV
       
        loadUpVotes()
        
        header.numberOfUpVotesLabel.text="\(self.upvotes)"
        header.usernameLabel.text = PFUser.current()?.username
        
        let imageData = User.current()?.avatar
    
            if (imageData != nil) {
                
                imageData?.getDataInBackground(block: { (data, error) in
                
                if (data != nil) {
                    let image = UIImage(data: data!)
                    if (image != nil) {
                        header.profileImage.image = image }
                        header.profileImage.layer.cornerRadius = header.profileImage.frame.size.height/1.31
                        header.profileImage.clipsToBounds = true
                    }
                })
            }
        
         return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideList.count
    }

    
    //cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GuideCVC
        let guide = guideList[(indexPath as NSIndexPath).row]
        
        let imageName = "\(guide.title)"
        var image = UIImage(named: imageName)
        let jpegImage = UIImageJPEGRepresentation(image!, 1)
 
        image = (UIImage(data: jpegImage!))
        
        cell.heroIcon.image = image
        cell.guidePosition.text = guide.heroGuidePosition
        cell.authorName.text = guide.username
        cell.heroName.text = guide.heroGuideName
        cell.likeNumber.text = "\(guide.guideLikes)"
        cell.numberOfViews.text = "\(guide.guideNumOfViews)"
        cell.dateCreated.text = (guide.createdAt as NSDate?)?.dateTimeAgo()
        cell.deleteButton.isHidden = true
        
        if ((cell.authorName.text! == User.current()?.username!) || (User.current()?.username! == "DotaMate")) && (User.current()?.username! != "Guest") {
            cell.deleteButton.isHidden = false
        }
        
        cell.outletForLike.isSelected = guide.userLiked
        cell.delegate = self
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadMoreGuides()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="observe"  {
            
            let destVC = segue.destination as! GuideObserveVC
            
            if let cell = sender as? GuideCVC {
                destVC.backGroundImageProsto = cell.heroIcon.image
                
                if let indexPath = collectionView?.indexPath(for: cell){
                    destVC.guideShown = guideList[(indexPath as NSIndexPath).row]
                }
            }
        }
    }
    
    func loadUpVotes(){
        let query = PFQuery(className:"Guide")
        let text = "\((PFUser.current()?.username!)!)"
        query.whereKey("username", equalTo: text)
        var counter = 0
        
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        counter+=object.object(forKey: "guideLikes") as! Int
                    }
                }
                self.upvotes=counter
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
}

extension profileVC: GuideCVCDelegate {
    
    func deleteButtonDidPress(_ cell: GuideCVC, button: UIButton) {
        
        let indexPath = collectionView?.indexPath(for: cell)
        let guide = guideList[((indexPath as NSIndexPath?)?.row)!]
       
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Delete") {
                self.deleteGuide(guide)
        }
        
        alertView.addButton("Cancel") {
            alertView.hideView()
        }
        
        alertView.showError("Delete Guide?", subTitle: "Are you sure you want to delete your guide?", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
    }
    
    func deleteGuide(_ guide: Guide){
        let currentGuide = guide
        currentGuide.deleteEventually()
        loadGuides()
        self.collectionView!.reloadData()
    }
    
    func likeButtonDidPress(_ cell: GuideCVC, button: UIButton) {
        if (((User.current()?.username!)! != "Guest")) {
            
            let indexPath = collectionView?.indexPath(for: cell)
            let guide = guideList[(indexPath! as NSIndexPath).row]
        
            if guide.userLiked {
                guide.unlike(User.current()!){ _ in}
                self.collectionView?.reloadData()

            } else {
                guide.like { _ in
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        
            collectionView?.reloadData()
        
        } else {
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: true
            )
            
            let alertView = SCLAlertView(appearance: appearance)
        
            alertView.showSuccess("Login as User :)", subTitle: "You have to login as User in order to like the Guides", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        }
    }
}
