//
//  TempUnit+Strategy.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

// MARK: - Temperature Unit
enum TempUnit: String {
    case celsius, fahrenheit
    var expression: String {
        switch self {
        case .celsius: return "℃"
        case .fahrenheit: return "℉"
        }
    }
    
    var title: String {
        switch self {
        case .celsius: return "섭씨"
        case .fahrenheit: return "화씨"
        }
    }
    
    var strategy: TempUnitStrategy {
        switch self {
        case .celsius:
            return Celsius(unit: self)
        case .fahrenheit:
            return Fahrenheit(unit: self)
        }
    }
    
    mutating func toggle() {
        switch self {
        case .celsius:
            self = .fahrenheit
        case .fahrenheit:
            self = .celsius
        }
    }
}


protocol TempUnitStrategy {
    var unit: TempUnit { get }
    func expressionToString(_ temperature: Double) -> String
}

struct Celsius: TempUnitStrategy {
    let unit: TempUnit
    
    init(unit: TempUnit) {
        self.unit = unit
    }
    
    func expressionToString(_ temperature: Double) -> String {
        return "\(temperature)\(unit.expression)"
    }
}

struct Fahrenheit: TempUnitStrategy {
    let unit: TempUnit
    
    init(unit: TempUnit) {
        self.unit = unit
    }
    
    func expressionToString(_ temperature: Double) -> String {
        let fahrenheit = TempConverter.convertToFahrenheit(with: temperature)
        return "\(fahrenheit)\(unit.expression)"
    }
}
