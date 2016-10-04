//
//  OutlinedText.swift
//  DotaMate
//
//  Created by Philip DesJean on 10/2/16.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit

class OutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 5
    var outlineColor: UIColor = UIColor.black
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
