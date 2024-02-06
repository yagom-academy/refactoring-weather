//
//  TemperatureUnit.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import Foundation

enum TemperatureUnit: String {
    case metric, imperial
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
}
