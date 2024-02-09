//
//  TemperatureUnit.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/4/24.
//

import Foundation

enum TemperatureUnit: String {
    case metric, imperial
    
    var strategy: TemperatureStrategy {
        switch self {
        case .metric: return MetricStrategy()
        case .imperial: return ImperialStrategy()
        }
    }
    
    func change() -> TemperatureUnit {
        switch self {
        case .metric: return .imperial
        case .imperial: return .metric
        }
    }
}
