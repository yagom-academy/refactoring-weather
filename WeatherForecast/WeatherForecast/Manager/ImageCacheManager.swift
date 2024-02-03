//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Kant on 2/3/24.
//

import UIKit

class ImageCacheManager {
    
    let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    func setImage(urlString: String) async -> UIImage? {
        if let image = imageCache.object(forKey: urlString as NSString) {
            return image
        }
        
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return nil
        }
        
        imageCache.setObject(image, forKey: urlString as NSString)
        
        return image
    }
    
    func loadImage(from iconName: String) async -> UIImage? {
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        if let image = await setImage(urlString: urlString) {
            return image
        }
        return nil
    }
}
