//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
final class WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}

// MARK: - List
final class WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
}

// MARK: - MainClass
final class MainInfo: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
final class Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    var iconPath : String { get { return "https://openweathermap.org/img/wn/\(icon)@2x.png" }}
}

// MARK: - City
final class City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coord
final class Coord: Decodable {
    let lat, lon: Double
}

