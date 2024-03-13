//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit

protocol ImageCacheProtocol {
    func set(_ image: UIImage, forKey key: NSString) throws // 용량 등의 문제로 캐싱 실패를 가정하여 throws
    func get(forKey key: NSString) -> UIImage?
}

struct ImageCacheNSCache: ImageCacheProtocol {
    private let cache: NSCache<NSString, UIImage> = NSCache()
    
    func set(_ image: UIImage, forKey: NSString) throws {
        cache.setObject(image, forKey: forKey)
    }
    
    func get(forKey: NSString) -> UIImage? {
        cache.object(forKey: forKey)
    }
}

struct ImageCache {
    private let caches: [ImageCacheProtocol] = [ImageCacheNSCache()]
    
    func set(_ image: UIImage, forKey key: NSString) {
        for cache in caches {
            do {
                try cache.set(image, forKey: key)
                return
            } catch {
                
            }
        }
        
        // 캐싱 실패
    }
    
    func get(forKey key: NSString) -> UIImage? {
        for cache in caches {
            if let result: UIImage = cache.get(forKey: key) {
                return result
            }
        }
        return nil
    }
    
    static var shared: Self = .init()
}
