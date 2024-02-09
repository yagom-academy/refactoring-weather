//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by 강동영 on 1/31/24.
//

import UIKit

// 프로토콜 이름 수정
protocol Cachable {
    subscript(key: any Hashable) -> UIImage? { get set }
    func removeAll()
}

final class ImageCache: Cachable {
    private var cache: NSCache<NSString, UIImage>
    
    init(cache: NSCache<NSString, UIImage>) {
        self.cache = cache
    }
    
    subscript(key: any Hashable) -> UIImage? {
        get {
            if let key = key as? NSString {
                return cache.object(forKey: key)
            } else {
                return nil
            }
        }
        set {
            if let key = key as? NSString {
                guard let value = newValue else {
                    cache.removeObject(forKey: key as NSString)
                    return
                }
                
                cache.setObject(value, forKey: key as NSString)
            }
        }
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
