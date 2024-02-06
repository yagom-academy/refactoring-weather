//
//  WeatherDataModel.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/6/24.
//

import Foundation

class WeatherForecast {
    
    private let weatherForecastInfo: WeatherForecastInfo
    private let temperatureUnit: TemperatureUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, temperatureUnit: TemperatureUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.temperatureUnit = temperatureUnit
    }
    
    var temperature: String {
        return "\(weatherForecastInfo.main.temp)\(temperatureUnit.expression)"
    }
    
    var currentTemperature: String {
        return "현재 기온 : \(weatherForecastInfo.main.temp)\(temperatureUnit.expression)"
    }
    
    var feelsLikeTemperature: String {
        return "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(temperatureUnit.expression)"
    }
    
    var maxTemperature: String {
        return "최고 기온 : \(weatherForecastInfo.main.tempMax)\(temperatureUnit.expression)"
    }
    
    var minTemperature: String {
        return "최저 기온 : \(weatherForecastInfo.main.tempMin)\(temperatureUnit.expression)"
    }
    
    var precipitation: String {
        return "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
    }
    
    var humidity: String {
        return "습도 : \(weatherForecastInfo.main.humidity)%"
    }
    
    /// Returns String in "ko_KR" locale formatted as  "yyyy-MM-dd(EEEEE) a HH:mm"
    /// - Return Value  example: "2024-01-20(토) 오전 7:40"
    var longFormattedDate: String {
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter.string(from: date)
    }
    
    var weatherMainDescription: String {
        return weatherForecastInfo.weather.main
    }
    
    var weatherDetailDescription: String {
        return weatherForecastInfo.weather.description
    }
    
    var weatherIcon: String {
        return weatherForecastInfo.weather.icon
    }
}
