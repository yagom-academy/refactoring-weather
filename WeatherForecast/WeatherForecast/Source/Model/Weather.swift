//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

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
    
    init(id: Int, name: String, coord: Coord, country: String, population: Int, timezone: Int, sunrise: TimeInterval, sunset: TimeInterval) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    static let mock: City = City(id: 0, name: "", coord: Coord.mock, country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0)
}

// MARK: - Coord
struct Coord: Decodable {
    let lat, lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    static let mock: Coord = Coord(lat: 0, lon: 0)
}
