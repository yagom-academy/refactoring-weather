//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by 강동영 on 1/31/24.
//

import UIKit

// 프로토콜 이름 수정
protocol Cachable {
    associatedtype Key: Hashable
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
    func removeAll()
}

final class ImageCache: Cachable {
    private var cache: NSCache<NSString, UIImage>
    typealias Key = String
    typealias Value = UIImage
    
    init(cache: NSCache<NSString, UIImage>) {
        self.cache = cache
    }
    
    subscript(key: Key) -> Value? {
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
