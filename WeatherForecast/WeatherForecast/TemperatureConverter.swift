//
//  TemperatureConverter.swift
//  WeatherForecast
//
//  Created by Kant on 2/4/24.
//

import Foundation

class TemperatureConverter {
    
    enum UI {
        static let metric = "섭씨"
        static let imperial = "화씨"
    }
    
    private var tempUnit: TempUnit = .metric
    
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
