//
//  City.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/20/24.
//

import Foundation

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
