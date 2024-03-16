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
    
    func loadUIImage(fromUrl urlString: String) async -> UIImage? {
        if let image = getImageFromCache(withKey: urlString) {
            return image
        }
        
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data)
        else {
            return nil
        }
        
        // 이미지 캐시에 저장하는 작업은 비동기로 처리
        Task {
            imageCache.setObject(image, forKey: urlString as NSString)
        }
        
        return image
    }
    
    func loadUIImage(fromFile filePath: String) async -> UIImage? {
        if let image = getImageFromCache(withKey: filePath) {
            return image
        }
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath),
              let data = fileManager.contents(atPath: filePath),
              let image: UIImage = UIImage(data: data) 
        else {
            return nil
        }
        
        return image
    }
    
    private func getImageFromCache(withKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        if let image = imageCache.object(forKey: cacheKey as NSString) {
            return image
        }
        return nil
    }
}
