//
//  UIImage+.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/2/24.
//

import UIKit


extension UIImageView {
    static private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func loadImage(with urlString: String) {
        if let image = Self.imageChache.object(forKey: urlString as NSString) {
            self.image = image
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            Self.imageChache.setObject(image, forKey: urlString as NSString)
            
            self.image = image
        }
    }
}
