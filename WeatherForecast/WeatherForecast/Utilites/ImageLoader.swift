//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/13/24.
//

import UIKit

enum ImageLoadError: Error {
    case invalidImage
}

protocol ImageLoadable {
    func fetchImage(_ url: String) async throws -> UIImage
    func fetchImage(with urlString: String) async throws -> UIImage
}

final class ImageLoader: ImageLoadable {
    static let shared: ImageLoader = .init()
    
    private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    private init() {}
    
    func fetchImage(_ url: String) async throws -> UIImage {
        if let image = imageChache.object(forKey: url as NSString) {
            return image
        }
        
        return try await fetchImage(with: url)
    }
    
    func fetchImage(with urlString: String) async throws -> UIImage {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            throw ImageLoadError.invalidImage
        }
        
        imageChache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
