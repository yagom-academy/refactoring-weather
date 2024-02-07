//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import Foundation


struct WeatherForecast {
    let title: Name?
    let description: Name?
    let temp: Temperature
    let feelsLike: Temperature
    let tempMax: Temperature
    let tempMin: Temperature
    let pop: Probability
    let humidity: Probability
    let iconUrl: WeatherIcon
    let updatedDate: Time
}

struct Temperature {
    private let celsius: Double
    
    init(_ celsius: Double) {
        self.celsius = celsius
    }
    
    func displayValue(with tempUnit: TempUnit) -> String {
        let value: Double
        
        switch tempUnit {
        case .metric:
            value = celsius
        case .imperial:
            let fahrenheit = (celsius * 9 / 5) + 32
            value = fahrenheit
        }
        
        return "\(value)\(tempUnit.expression)"
    }
}

struct Probability: CustomStringConvertible {
    let value: String
    
    init(_ percent: Double) {
        self.value = String(format: "%.1f%%", percent)
    }
    
    var description: String {
        value
    }
}

struct WeatherIcon {
    let value: String
    
    init(_ iconName: String) {
        self.value = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
}
