//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import UIKit

final class ImageCacheManager {
    static let shared: ImageCacheManager = .init()
    private var imageCache: NSCache<NSString, UIImage> = .init()
    private init() {}
    
    func setImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
