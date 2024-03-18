//
//  ImageCacher.swift
//  WeatherForecast
//
//  Created by 구민영 on 3/18/24.
//

import UIKit

struct ImageChacher {
    private init() {}
    static let shared = ImageChacher()
    
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func chachedImage(from urlString: String) -> UIImage? {
        return imageChache.object(forKey: urlString as NSString)
    }
    
    func load(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = chachedImage(from: urlString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            imageChache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
