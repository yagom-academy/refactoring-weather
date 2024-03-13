//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//


// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
}
