//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/20/24.
//

import Foundation

enum TempUnit: String {
    case metric, imperial
    
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .metric: return "섭씨"
        case .imperial: return "화씨"
        }
    }
}

