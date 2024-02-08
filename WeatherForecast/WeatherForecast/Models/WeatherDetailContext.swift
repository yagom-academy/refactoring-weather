//
//  WeatherDetailContext.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class WeatherDetailContext {
    let weatherForecastInfo: WeatherForecastInfo
    let cityInfo: City
    let tempUnit: TemperatureUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TemperatureUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
    }
}
