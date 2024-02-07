//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
struct WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}

// MARK: - List
struct WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
}

// MARK: - MainClass
struct MainInfo: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

extension MainInfo {
    func tempValue(at tempUnit: TempUnit) -> Double {
        return tempUnit.tempStrategy.changeValue(from: temp)
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - City
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
    
    var tempStrategy: TempUnitStrategy {
        switch self {
        case .metric:
            return MetricStrategy()
        case .imperial:
            return ImperialStrategy()
        }
    }
}

// MARK: - TempUnitStrategy
protocol TempUnitStrategy {
    func changeValue(from temp: Double) -> Double
}

struct MetricStrategy: TempUnitStrategy {
    func changeValue(from temp: Double) -> Double {
        return temp
    }
}

struct ImperialStrategy: TempUnitStrategy {
    func changeValue(from temp: Double) -> Double {
        let changedTemp: Double = (temp * 9 / 5) + 32
        let formattedString = String(format: "%.2f", changedTemp)
        guard let formattedDouble = Double(formattedString) else {
            return changedTemp
        }
        return formattedDouble
    }
}
