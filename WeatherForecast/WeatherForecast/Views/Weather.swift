//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
class WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}

// MARK: - List
struct WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
    
    func getWeather() -> String {
        return weather.main
    }
    
    func getDescription() -> String {
        return weather.description
    }
    
    func getTemp() -> Double {
        return main.temp
    }
    
    func getTempMax() -> Double {
        return main.tempMax
    }
    
    func getTempMin() -> Double {
        return main.tempMin
    }
    
    func getFeelsLike() -> Double {
        return main.feelsLike
    }
    
    func getPop() -> String {
        return "\(main.pop * 100)%"
    }
    
    func getHumidity() -> String {
        return "\(main.humidity)%"
    }
    
    func getIconName() -> String {
        return weather.icon
    }
}

// MARK: - MainClass
struct MainInfo: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Ci
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coord
struct Coord: Decodable {
    let lat, lon: Double
}

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
}

