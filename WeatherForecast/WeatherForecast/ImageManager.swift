//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/30/24.
//

import UIKit

protocol ImageManagerProtocol {
    func fetchImage(of iconName: String, completion: @escaping (UIImage?) -> ())
}

struct ImageManager: ImageManagerProtocol {
    
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func fetchImage(of iconName: String, completion: @escaping (UIImage?) -> ()) {
        
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        if let image = imageChache.object(forKey: urlString as NSString) {
            completion(image)
            return
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    imageChache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                } else {
                    print("Failed to create image from data!")
                    completion(nil)
                }
            }
            .resume()
        } else {
            print("Invalid url string!")
            completion(nil)
        }
    }
    
}
