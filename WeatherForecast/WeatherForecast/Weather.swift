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
class WeatherForecastInfo: Decodable {
    let date: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dateText: String
}

// MARK: - MainClass
class MainInfo: Decodable {
    let temperature, feelsLike, minTemperature, maxTemperature: Double
    let pressure, seaLevel, groundLevel, humidity, pop: Double
}

// MARK: - Weather
class Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - City
class City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coordinate
class Coordinate: Decodable {
    let latitude, longtitude: Double
}

// MARK: - Temperature Unit
enum TemperatureUnit: String {
    case metric, imperial
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
}

