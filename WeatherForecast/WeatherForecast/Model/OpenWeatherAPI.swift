//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Daegeon Choi on 2024/02/03.
//

import Foundation
import UIKit

protocol WeatherAPI {
    func fetchData(_ completion: @escaping (WeatherJSON) -> Void)
    func fetchImage(iconName: String, _ completion: @escaping (UIImage) -> Void)
}

class OpenWeatherAPI: WeatherAPI {
    
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func fetchData(_ completion: @escaping (WeatherJSON) -> Void) {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        completion(info)
    }
    
    func fetchImage(iconName: String, _ completion: @escaping (UIImage) -> Void) {
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
