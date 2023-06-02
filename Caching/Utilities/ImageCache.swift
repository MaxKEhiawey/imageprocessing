//
//  ImageCache.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import UIKit

class CacheManager {
    static let shared = CacheManager()
    private init() {}
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200//  100mb
        return cache
    }()
    
    func add(key: String, image: UIImage) {
        print("added to cache: \(key)")
        imageCache.setObject(image, forKey: key as NSString)
     }
    
    func get( key: String) -> UIImage? {
        print("got from cache: \(key)")
       return  imageCache.object(forKey: key as NSString)
    }
}
