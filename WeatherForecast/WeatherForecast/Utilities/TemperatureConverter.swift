//
//  TemperatureConverter.swift
//  WeatherForecast
//
//  Created by Kant on 2/4/24.
//

import Foundation

protocol TemperatureConverterProtocol {
    var tempUnit: TempUnit { get }
    func toggleTemperature() -> String
}

class TemperatureConverter: TemperatureConverterProtocol {
    
    var tempUnit: TempUnit = .metric
    
    func toggleTemperature() -> String {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            return UI.metric
        case .metric:
            tempUnit = .imperial
            return UI.imperial
        }
    }
}
