//
//  WeatherForecastModel.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/1/24.
//

import UIKit

final class WeatherForecastModel {
    private let decoder: CustomDecoder
    private var weatherJSON: WeatherJSON!
    private var dataFetcher: DataFetchable
    
    init(decoder: CustomDecoder, dataFetcher: DataFetchable) {
        self.decoder = decoder
        self.dataFetcher = dataFetcher
        self.weatherJSON = dataFetcher.fetchWeatherJSON()
    }
}


extension WeatherForecastModel {
    var city: City {
        return weatherJSON.city
    }
    
    var cityName: String {
        return weatherJSON.city.name
    }
    
    var weatherForecastCount: Int {
        return weatherJSON.weatherForecast.count
    }
    
    var weatherForecast: [WeatherForecastInfo] {
        return weatherJSON.weatherForecast
    }
}