//
//  BlurImage.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 22/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit


extension UIImageView{
    
    //Method 1
    func makeBlurImage(_ targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    //Method 2
    func convertToBlurImage(_ imageToBlur:UIImage) -> UIImage
    {
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        gaussianBlurFilter!.setValue(CIImage(cgImage: imageToBlur.cgImage!), forKey:kCIInputImageKey)
        
        let initialImage = CIImage(cgImage: imageToBlur.cgImage!)
        
        let finalImage = gaussianBlurFilter!.outputImage
        let finalImagecontext = CIContext(options: nil)
        
        let finalCGImage = finalImagecontext.createCGImage(finalImage!, from: initialImage.extent)
        return UIImage(cgImage: finalCGImage!)
    }
}
