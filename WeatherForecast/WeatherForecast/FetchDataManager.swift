//
//  FetchManager.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

protocol FetchDataManagerProtocol {
    func fetchWeatherData(completion: @escaping (WeatherData?) -> ())
}

struct FetchDataManager: FetchDataManagerProtocol {
    
    func fetchWeatherData(completion: @escaping (WeatherData?) -> ()) {
        
        let info: WeatherData
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            completion(nil)
            return
        }
        
        do {
            info = try jsonDecoder.decode(WeatherData.self, from: data)
            completion(info)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
