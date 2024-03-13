//
//  WeatherJSON.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//

// MARK: - Weather JSON Format
struct WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}
