//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Kant on 2/3/24.
//

import UIKit


protocol WeatherViewModelProtocol {
    var city: City? { get }
    var cityName: String { get }
    var weatherForecast: [WeatherForecastInfo]? { get }
    func fetchWeatherData()
}

final class WeatherViewModel: WeatherViewModelProtocol {
    
    private var weatherData: WeatherData?
    
    var weatherForecast: [WeatherForecastInfo]? {
        return weatherData?.weatherForecast
    }
    
    var city: City? {
        return weatherData?.city ?? nil
    }
    
    var cityName: String {
        return weatherData?.city.name ?? ""
    }
    
    func fetchWeatherData() {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        do {
            self.weatherData = try jsonDecoder.decode(WeatherData.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
