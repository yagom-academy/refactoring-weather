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
    
    var weatherMain: String { weather.main }
    var description: String { weather.description }
    
    var temp: Double { main.temp }
    var tempMax: Double { main.tempMax }
    var tempMin: Double { main.tempMin }
    var feelsLike: Double { main.feelsLike }
    
    var pop: String { "\(main.pop * 100)%" }
    var humidity: String { "\(main.humidity)%" }
    
    var iconName: String { weather.icon }
}

// MARK: - MainClass
class MainInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Double
    let seaLevel: Double
    let grndLevel: Double
    let humidity: Double
    let pop: Double
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
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
    
    var sunriseString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter.string(from: Date(timeIntervalSince1970: sunrise))
    }
    
    var sunsetString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter.string(from: Date(timeIntervalSince1970: sunset))
    }
}

// MARK: - Coord
class Coord: Decodable {
    let lat: Double
    let lon: Double
}
