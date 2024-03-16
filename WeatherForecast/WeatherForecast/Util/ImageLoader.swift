//
//  ImageFetcher.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/13/24.
//

import UIKit

final class ImageLoader {
    init(imageCache: NSCache<NSString, UIImage>) {
        self.imageCache = imageCache
    }
    
    let imageCache: NSCache<NSString, UIImage>
    
    func loadUIImage(from urlString: String) async -> UIImage? {
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            return image
        }
        
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data)
        else {
            return nil
        }
        
        imageCache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
