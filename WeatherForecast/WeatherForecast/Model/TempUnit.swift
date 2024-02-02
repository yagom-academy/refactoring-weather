//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/2/24.
//

import Foundation

// MARK: - Temperature Unit
enum TempUnit: String {
    case celsius, fahrenheit
        
    var strategy: TempUnitStrategy {
        switch self {
        case .celsius: 
            return CelsiusStrategy()
        case .fahrenheit:
            return FahrenheitStrategy()
        }
    }
    
    mutating func toggleTempUnit() {
        switch self {
        case .celsius:
            self = .fahrenheit
        case .fahrenheit:
            self = .celsius
        }
    }
}
