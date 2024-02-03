//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Kant on 2/3/24.
//

import UIKit

final class WeatherViewModel {
    
    private var weatherJSON: WeatherJSON?
    
    var weatherForecast: [WeatherForecastInfo]? {
        return weatherJSON?.weatherForecast
    }
    
    var city: City? {
        return weatherJSON?.city ?? nil
    }
    
    var cityName: String {
        return weatherJSON?.city.name ?? ""
    }
    
    func fetchWeatherJSON() {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        do {
            self.weatherJSON = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
