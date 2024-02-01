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
    
    var expressStrategy: TempExpression {
        switch self {
        case .metric:
            MetricTempUnit()
        case .imperial:
            ImperialTempUnit()
        }
    }
    
    mutating func change() {
        switch self {
        case .metric:
            self = .imperial
        case .imperial:
            self = .metric
        }
    }
}

protocol TempExpression {
    var expression: String { get }
    var text: String { get }
}

struct MetricTempUnit: TempExpression {
    let expression: String = "℃"
    let text: String = "섭씨"
}

struct ImperialTempUnit: TempExpression {
    let expression: String = "℉"
    let text: String = "화씨"
}

// MARK: - Weather Date Namespace

enum WeatherDate {
    static let format: String = "yyyy-MM-dd(EEEEE) a HH:mm"
}

// MARK: - Json Asset Name

enum JsonAssetName {
    static let weather: String = "weather"
}
