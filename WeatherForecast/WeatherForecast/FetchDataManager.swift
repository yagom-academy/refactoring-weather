//
//  FetchManager.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

protocol FetchDataManagerProtocol {
    func fetchWeatherJSON(completion: @escaping (WeatherJSON?) -> ())
}

struct FetchDataManager: FetchDataManagerProtocol {
    
    func fetchWeatherJSON(completion: @escaping (WeatherJSON?) -> ()) {
        
        let info: WeatherJSON
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            completion(nil)
            return
        }
        
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
            completion(info)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
