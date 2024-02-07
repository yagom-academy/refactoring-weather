//
//  Weather.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/6/24.
//

import Foundation

protocol WeatherInfoProtocol: AnyObject {
    var weatherForecastInfo: [WeatherForecastInfo] { get }
    var city: CityInfo { get }
    var temperatureUnit: TemperatureUnit { get set }
    func fetchWeatherForecastItem(at index: Int) -> WeatherForecast?
}

final class WeatherInfo: WeatherInfoProtocol {
    
    private(set) var weatherForecastInfo: [WeatherForecastInfo]
    private(set) var city: CityInfo
    var temperatureUnit: TemperatureUnit
    
    init(weatherForecast: [WeatherForecastInfo], city: CityInfo, temperatureUnit: TemperatureUnit) {
        self.weatherForecastInfo = weatherForecast
        self.city = city
        self.temperatureUnit = temperatureUnit
    }
    
    func fetchWeatherForecastItem(at index: Int) -> WeatherForecast? {
        guard index < self.weatherForecastInfo.count else { return nil }
        let weatherForecastItem = self.weatherForecastInfo[index]
        return WeatherForecast(weatherForecastInfo: weatherForecastItem,
                               temperatureUnit: temperatureUnit)
    }
}
