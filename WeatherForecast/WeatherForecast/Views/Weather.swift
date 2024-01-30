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
    var date: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        
        return formatter.string(from: Date(timeIntervalSince1970: dt))
    }
    
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
protocol TempUnit {
    var expression: String { get }
    var expressionTitle: String { get }
}
struct Metric: TempUnit {
    var expression: String = "℉"
    var expressionTitle: String = "화씨"
}

struct Imperial: TempUnit {
    var expression: String = "℃"
    var expressionTitle: String = "섭씨"
}

