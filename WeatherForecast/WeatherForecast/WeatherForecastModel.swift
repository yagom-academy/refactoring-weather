//
//  WeatherForecastModel.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/1/24.
//

import UIKit

class WeatherForecastModel {
    var weatherJSON: WeatherJSON!
    
    init() {
        fetchWeatherJSON()
    }
}

extension WeatherForecastModel {
    private func fetchWeatherJSON() {
        
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

        weatherJSON = info
    }
}

extension WeatherForecastModel {
    func getCityName() -> String {
        return weatherJSON.city.name
    }
    
    func getWeatherForecast() -> Int {
        return weatherJSON.weatherForecast.count
    }
}
