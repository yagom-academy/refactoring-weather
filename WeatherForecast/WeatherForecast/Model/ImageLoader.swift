//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Daegeon Choi on 2024/02/07.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared: ImageLoader = ImageLoader()
    
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func fetchImage(urlString: String, _ completion: @escaping (UIImage) -> Void) {
        if let image = imageChache.object(forKey: urlString as NSString) {
            completion(image)
            return
        }
        
        Task {
            await performImageLoad(urlString: urlString, completion)
        }
    }
    
    func performImageLoad(urlString: String, _ completion: @escaping (UIImage) -> Void) async {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return
        }
        
        imageChache.setObject(image, forKey: urlString as NSString)
        completion(image)
    }
}
