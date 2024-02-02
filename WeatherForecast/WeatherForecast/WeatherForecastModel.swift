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

        let assetConvertor = NSDataAssetConvertor()
        let decoder = CustomDecoder()
        guard let data = try? assetConvertor.data("weather"),
              let response = try? decoder.decode(WeatherJSON.self, data: data)
        else { return }
        
        weatherJSON = response
    }
}
