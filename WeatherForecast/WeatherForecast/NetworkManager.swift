//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/30/24.
//

import UIKit

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchWeatherJSON() -> WeatherJSON? {
        
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return info
        
    }
    
    
    func fetchImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
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
