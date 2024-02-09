//
//  TemperatureStrategy.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/4/24.
//

import Foundation

protocol TemperatureStrategy {
    var unitExpression: String { get }
    func convertTemperature(_ temperature: Double) -> String
}

struct MetricStrategy: TemperatureStrategy {
    let unitExpression: String = "섭씨"
    
    func convertTemperature(_ temperature: Double) -> String {
        return "\(temperature)℃"
    }
}

struct ImperialStrategy: TemperatureStrategy {
    let unitExpression: String = "화씨"
    private let conversionMultiplier: Double = 9 / 5
    private let conversionOffset: Double = 32.0
    
    func convertTemperature(_ temperature: Double) -> String {
        let fahrenheitTemperature = temperature * conversionMultiplier + conversionOffset
        return String(format: "%.2f℉", fahrenheitTemperature)
    }
}

