//
//  Weather.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/3/24.
//

import Foundation

// MARK: - Weather JSON Format
struct Weather {
    private(set) var weatherForecast: [WeatherForecastInfo]
    private(set) var city: CityInfo
}

// MARK: - List
struct WeatherForecastInfo {
    private(set) var dt: TimeInterval
    private(set) var main: MainInfo
    private(set) var weather: WeatherInfo
    private(set) var dtTxt: String
}

// MARK: - MainClass
struct MainInfo {
    private(set) var temp, feelsLike, tempMin, tempMax: Double
    private(set) var pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
struct WeatherInfo {
    private(set) var id: Int
    private(set) var main: String
    private(set) var description: String
    private(set) var icon: String
}

// MARK: - City
struct CityInfo {
    private(set) var id: Int
    private(set) var name: String
    private(set) var coord: Coord
    private(set) var country: String
    private(set) var population, timezone: Int
    private(set) var sunrise, sunset: TimeInterval
}

// MARK: - Coord
struct Coord {
    private(set) var lat, lon: Double
}
