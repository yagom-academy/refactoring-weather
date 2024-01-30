//
//  IconService.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import UIKit

struct ImageService: ImageServiceable {
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func getIcon(iconName: String, completion: @escaping (UIImage) -> ()) {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        if let image = imageChache.object(forKey: urlString as NSString) {
            completion(image)
            return
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageChache.setObject(image, forKey: urlString as NSString)
            completion(image)
        }
    }
}
