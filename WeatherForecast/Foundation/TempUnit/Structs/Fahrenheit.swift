//
//  Fahrenheit.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

struct Fahrenheit: TempUnit {
    private(set) var expression: String = "℉"
    private(set) var expressionTitle: String = "화씨"
    
    func formattedTemp(_ temp: Double) -> String {
        return "\(celsiusToFahrenheit(temp: temp))\(expression)"
    }
    
    func formattedTempMax(_ temp: Double) -> String {
        return "\(celsiusToFahrenheit(temp: temp))\(expression)"
    }
    
    func formattedTempMin(_ temp: Double) -> String {
        return "\(celsiusToFahrenheit(temp: temp))\(expression)"
    }
    
    func formattedFeelsLike(_ temp: Double) -> String {
        return "\(celsiusToFahrenheit(temp: temp))\(expression)"
    }
}
