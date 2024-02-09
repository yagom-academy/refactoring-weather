//
//  Celsius.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

struct Celsius: TempUnit {
    private(set) var expression: String = "℃"
    private(set) var expressionTitle: String = "섭씨"
    
    func formattedTemp(_ temp: Double) -> String {
        return "\(temp)\(expression)"
    }
    
    func formattedTempMax(_ temp: Double) -> String {
        return "\(temp)\(expression)"
    }
    
    func formattedTempMin(_ temp: Double) -> String {
        return "\(temp)\(expression)"
    }
    
    func formattedFeelsLike(_ temp: Double) -> String {
        return "\(temp)\(expression)"
    }
}
