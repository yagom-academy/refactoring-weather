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
    
    private func convertTemp(temp: Double) -> String {
        if temperatureUnit == .metric {
            return "\(temp)\(temperatureUnit.expression)"
        }
        let convertedTemp: Double = (temp * 9 / 5) + 32
        let formattedTemp: String = String(format: "%.2f", convertedTemp)
        return "\(formattedTemp)\(temperatureUnit.expression)"
    }
    
    var temperature: String {
        return convertTemp(temp: weatherForecastInfo.main.temp)
    }
    
    var currentTemperature: String {
        return "현재 기온 : \(convertTemp(temp: weatherForecastInfo.main.temp))"
    }
    
    var feelsLikeTemperature: String {
        return "체감 기온 : \(convertTemp(temp: weatherForecastInfo.main.feelsLike))"
    }
    
    var maxTemperature: String {
        return "최고 기온 : \(convertTemp(temp: weatherForecastInfo.main.tempMax))"
    }
    
    var minTemperature: String {
        return "최저 기온 : \(convertTemp(temp: weatherForecastInfo.main.tempMin))"
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
