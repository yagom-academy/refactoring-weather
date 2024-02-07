//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Daegeon Choi on 2024/02/03.
//

import Foundation
import UIKit

protocol WeatherAPI {
    var imageLoader: ImageLoader { get }
    func fetchData(_ completion: @escaping (WeatherJSON) -> Void)
    func fetchImage(iconName: String, _ completion: @escaping (UIImage) -> Void)
    func iconImageUrlString(iconName: String) -> String
}

class OpenWeatherAPI: WeatherAPI {
    
    let imageLoader: ImageLoader = ImageLoader.shared
    
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
        let urlString: String = iconImageUrlString(iconName: iconName)
        imageLoader.fetchImage(urlString: urlString, completion)
    }
    
    func iconImageUrlString(iconName: String) -> String {
        return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
}
