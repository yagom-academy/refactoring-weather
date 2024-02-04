//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/5/24.
//

import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func fetchWeatherData(completion: @escaping (Result<WeatherJSON, Error>) -> Void)
}

class WeatherDataManager: WeatherDataManagerDelegate {
    func fetchWeatherData(completion: @escaping (Result<WeatherJSON, Error>) -> Void) {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
            completion(.success(info))
        } catch {
            completion(.failure(error))
        }
    }
}
