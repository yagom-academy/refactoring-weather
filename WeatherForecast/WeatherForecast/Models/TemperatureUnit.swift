//
//  TemperatureUnit.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import Foundation

enum TemperatureUnit: String {
    case metric = "섭씨"
    case imperial = "화씨"
    
    mutating func toggle() {
        if self == .metric {
            self = .imperial
            return
        }
        self = .metric
    }
    
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
    
    var description: String {
        return self.rawValue
    }
}
