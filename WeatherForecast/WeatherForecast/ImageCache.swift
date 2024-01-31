//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by 강동영 on 1/31/24.
//

import UIKit

protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
    func removeAll()
}

class ImageCache: Cache {
    private let cache: NSCache<NSString, UIImage> = NSCache()
    typealias Key = String
    typealias Value = UIImage
    
    subscript(key: String) -> UIImage? {
        get {
            return cache.object(forKey: key as NSString)
        }
        set {
            guard let value = newValue else {
                cache.removeObject(forKey: key as NSString)
                return
            }
            cache.setObject(value, forKey: key as NSString)
        }
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
