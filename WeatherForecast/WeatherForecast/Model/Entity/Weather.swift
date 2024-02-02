//
//  Weather.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/3/24.
//

import Foundation

// MARK: - Weather JSON Format
struct Weather {
    let weatherForecast: [WeatherForecastInfo]
    let city: CityInfo
}

// MARK: - List
struct WeatherForecastInfo {
    let dt: TimeInterval
    let main: MainInfo
    let weather: WeatherInfo
    let dtTxt: String
}

// MARK: - MainClass
struct MainInfo {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
struct WeatherInfo {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - City
struct CityInfo {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coord
struct Coord {
    let lat, lon: Double
}
