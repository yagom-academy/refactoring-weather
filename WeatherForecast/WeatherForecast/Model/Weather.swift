//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
struct WeatherJSON: Decodable {
    static let changeWeaterJsonKey: String = "changeWeatherJson"
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}

// MARK: - List
struct WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
    
    var dateString: String {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = .init(identifier: "ko_KR")
            df.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
            return df
        }()
        
        let date: Date = Date(timeIntervalSince1970: self.dt)
        return dateFormatter.string(from: date)
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
