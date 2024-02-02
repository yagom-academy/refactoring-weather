//
//  TempConverter.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

struct TempConverter {
    static func convertToFahrenheit(with celsius: Double) -> Double {
        let fahrenheit = celsius * 1.8 + 32
        return fahrenheit
    }
    
    static func convertToCelsius(with fahrenheit: Double) -> Double {
        let celsius = (fahrenheit - 32) / 1.8
        return celsius
    }
}
