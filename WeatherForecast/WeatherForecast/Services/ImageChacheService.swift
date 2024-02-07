//
//  ImageChacheService.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/6/24.
//

import Foundation

protocol ImageChacheService {
    func fetchImage(urlString: String) async -> ImageCache?
}

final class DefaultImageChacheService: ImageChacheService {
    private let imageDataChache: NSCache<NSString, ImageCache> = NSCache()
    
    static let shared: DefaultImageChacheService = DefaultImageChacheService()
    
    private init() { }
    
    func fetchImage(urlString: String) async -> ImageCache? {
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageCache: ImageCache = imageDataChache.object(forKey: urlString as NSString) {
           return imageCache
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let imageCache = ImageCache(data: data)
            imageDataChache.setObject(imageCache, forKey: urlString as NSString)
            return imageCache
        } catch {
            // TODO: 통신 에러처리 필요
            return nil
        }
    }
}
