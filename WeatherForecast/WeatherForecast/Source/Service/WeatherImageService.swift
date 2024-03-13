//
//  WeatherImageService.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/13.
//


import UIKit

final class WeatherImageService {
    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    func fetchImage(iconName: String, completion: @escaping (UIImage) -> ()) {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
                
        if let image = imageCache.object(forKey: urlString as NSString) {
            completion(image)
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            completion(image)
        }
    }
}
