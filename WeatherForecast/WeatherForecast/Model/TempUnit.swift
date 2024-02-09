//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by Daegeon Choi on 2024/02/08.
//

import Foundation

// MARK: - Temperature Unit
protocol TempUnit {
    var expression: String { get }
    var title: String { get }
    func convertedValue(temp: Double) -> Double
}

extension TempUnit {
    func nextUnit() -> TempUnit {
        if self is Metric {
            return Imperial()
        }
        
        return Metric()
    }
}

struct Metric: TempUnit {
    var expression: String = "℃"
    var title: String = "섭씨"
    func convertedValue(temp: Double) -> Double {
        return temp
    }
}

struct Imperial: TempUnit {
    var expression: String = "℉"
    var title: String = "화씨"
    func convertedValue(temp: Double) -> Double {
        return temp * 1.8 + 32.0
    }
}
