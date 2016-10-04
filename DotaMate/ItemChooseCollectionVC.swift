//
//  ItemChooseCollectionVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 14/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Kingfisher
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


private let reuseIdentifier = "cellOfItemWithLabel"
private let segueID = "backToGuideGiveItem"

protocol ItemChooseCollectionVCDelegate {
    func didChoseItem(_ item: Item)
    
}

class ItemChooseCollectionVC: UICollectionViewController {
    
    var delegate: ItemChooseCollectionVCDelegate?
    
    var itemFullList = [Item]()
    var chosenItem : Item!
    var indexPressed : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.layoutSubviews()
    }

    // MARK: UICollectionViewDataSource
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let bounds = self.view.bounds
        let ratio: CGFloat = 0.852
        let width: CGFloat = bounds.width / 4 - flowLayout.minimumInteritemSpacing * 3
        let height = width * ratio
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemFullList.sort(by: { $0.cost < $1.cost })
        return itemFullList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ItemWithCellCVC {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemWithCellCVC
        
        cell.itemName.text = itemFullList[(indexPath as NSIndexPath).row].itemLocalizedName
        
        let item = itemFullList[(indexPath as NSIndexPath).row]
        
        if let itemImageURL = item.itemImageURL {
            cell.itemImage.kf.setImage(with: URL(string: itemImageURL)!, options: [.transition(ImageTransition.fade(0.6))])
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didChoseItem(self.itemFullList[(indexPath as NSIndexPath).row])
        navigationController?.popViewController(animated: true)
    }
}
