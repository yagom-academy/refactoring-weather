//
//  WeatherJSON.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//

// MARK: - Weather JSON Format
protocol WeatherDataProtocol {
    var weatherForecast: [WeatherForecastInfo] { get }
    var city: City { get }
}

struct WeatherJSON: Decodable, WeatherDataProtocol {
    private let _weatherForecast: [WeatherForecastInfo]
    private let _city: City
    
    var weatherForecast: [WeatherForecastInfo] {
        return _weatherForecast
    }
    
    var city: City {
        return _city
    }
}
