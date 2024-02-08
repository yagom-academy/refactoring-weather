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


// MARK: - Coord
final class Coord: Decodable {
    let lat, lon: Double
}
