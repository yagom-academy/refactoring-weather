//
//  WeatherDetailContext.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class WeatherDetailContext {
    let weather: Weather
    let city: City
    let tempUnit: TemperatureUnit
    
    init(weather: Weather, city: City, tempUnit: TemperatureUnit) {
        self.weather = weather
        self.city = city
        self.tempUnit = tempUnit
    }
}
