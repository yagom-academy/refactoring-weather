//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation


// MARK: - List


// MARK: - MainClass


// MARK: - Weather
final class Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
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
