//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - Temperature Unit
protocol TempUnit {
    var expression: String { get }
    var expressionTitle: String { get }
    func formattedTemp(_ temp: Double) -> String
    func formattedTempMax(_ temp: Double) -> String
    func formattedTempMin(_ temp: Double) -> String
    func formattedFeelsLike(_ temp: Double) -> String
}

extension TempUnit {
    func celsiusToFahrenheit(temp: Double) -> String {
        return String(format: "%.2f", (temp * 1.8) + 32)
    }
    
    func fahrenheitToCelsius(temp: Double) -> String {
        return String(format: "%.2f", (temp - 32) * 1.8)
    }
}
