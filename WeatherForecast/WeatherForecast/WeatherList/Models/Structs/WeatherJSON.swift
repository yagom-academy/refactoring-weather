//
//  WeatherJSON.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - Weather JSON Format
struct WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}
