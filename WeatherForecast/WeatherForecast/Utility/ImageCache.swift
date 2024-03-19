//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/20/24.
//

import UIKit

protocol ImageCachable {
  subscript(key: String) -> UIImage? { get set }
  func removeAll()
}

final class ImageCache: ImageCachable {
  private let cache = NSCache<NSString, UIImage>()
  
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
