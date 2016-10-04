//
//  GuideCVC.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 12/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse

protocol GuideCVCDelegate {
    func likeButtonDidPress(_ cell: GuideCVC, button: UIButton)
    func deleteButtonDidPress(_ cell:GuideCVC, button: UIButton)
}

class GuideCVC: UICollectionViewCell {

    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var heroIcon: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var guidePosition: UILabel!
    @IBOutlet weak var outletForLike: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: GuideCVCDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func likeButtonDidPress(_ button: UIButton){
        guard let delegate = delegate else {return}
        
        delegate.likeButtonDidPress(self, button: button)
    }

    @IBAction func deleteButtonDidPress(_ sender: UIButton) {
        guard let delegate = delegate else {return}
        
        delegate.deleteButtonDidPress(self, button: sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroName.text = ""
    }
}
