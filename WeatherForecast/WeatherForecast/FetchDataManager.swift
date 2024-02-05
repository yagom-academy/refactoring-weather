//
//  FetchManager.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

protocol FetchDataManagerProtocol {
    func fetchWeatherData() async -> WeatherData?
}

struct FetchDataManager: FetchDataManagerProtocol {
    
    func fetchWeatherData() async -> WeatherData? {
        
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        do {
            let info: WeatherData = try jsonDecoder.decode(WeatherData.self, from: data)
            return info
        } catch {
            print("Could not decode data \(error.localizedDescription)")
            return nil
        }

    }
}
