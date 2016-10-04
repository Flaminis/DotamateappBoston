////
////  ImageCache.swift
////  DotaLobby
////
////  Created by Yerbol Kopzhassar on 5/16/16.
////  Copyright © 2016 Flaminis. All rights reserved.
////
//
//import UIKit
//
//class ImageCache {
//    static let imageCache = NSCache()
//    
//    class func fetchImageWithURL(_ stringURL:String) -> UIImage? {
//        
//        let cache = self.imageCache
//        var cachedImage:UIImage?
//        
//        if let image = cache.object(forKey: stringURL) as? UIImage {
//            cachedImage = image
//        } else {
//            
//            guard let url = URL(string:stringURL) else{
//                return cachedImage
//            }
//            
//            guard let data = try? Data(contentsOf: url) else{
//                return cachedImage
//            }
//            
//            guard let image = UIImage(data:data) else {
//                return cachedImage
//            }
//            
//            cachedImage = image
//            cache.setObject(image, forKey: stringURL)
//        }
//        
//        return cachedImage
//    }
//    
//    class func hasImageInCacheOfURL(_ stringURL:String) -> Bool {
//        
//        let cache = self.imageCache
//        
//        if (cache.object(forKey: stringURL)) != nil {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    class func downloadAndCacheImageWithURL(_ url:String){
//        let cache = self.imageCache
//        
//        guard let data = try? Data(contentsOf: URL(string: url)!) else{
//            return
//        }
//        
//        guard let image = UIImage(data:data) else {
//            return
//        }
//        
//        cache.setObject(image, forKey: url)
//    }
//    
//    class func cacheImage(_ image:UIImage,withKey string:String){
//        let cache = self.imageCache
//        cache.setObject(image, forKey: string)
//    }
//    
//    class func deleteCachedImageWithURL(_ url:String){
//        let cache = self.imageCache
//        cache.removeObject(forKey: url)
//    }
//}
