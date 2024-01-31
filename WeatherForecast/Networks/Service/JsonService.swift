//
//  JsonService.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import UIKit

final class JsonService: JsonServiceable {
    
    func fetchWeatherJSON() -> WeatherJSON? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        let weatherInfo: WeatherJSON
        do {
            weatherInfo = try jsonDecoder.decode(WeatherJSON.self, from: data)
            return weatherInfo
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
