//
//  TempUnit+Strategy.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/12/24.
//

import Foundation

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    
    var strategy: TempUnitStrategy {
        switch(self) {
        case .metric:
            return MetricUnitStrategy()
        case .imperial:
            return ImperialUnitStrategy()
        }
    }
}

protocol TempUnitStrategy {
    var title: String { get }
    var unitSymbol: String { get }
    
    func convertTemperture(metric: Double) -> Double
}

class MetricUnitStrategy: TempUnitStrategy {
    var title: String = "섭씨"
    var unitSymbol: String = "℃"
    
    func convertTemperture(metric: Double) -> Double {
        return metric
    }
}

class ImperialUnitStrategy: TempUnitStrategy {
    var title: String = "화씨"
    var unitSymbol: String = "℉"
    
    func convertTemperture(metric: Double) -> Double {
        // TODO: 좀 더 개선을 하고싶음
        return round((metric * 5.0 / 9.0 + 32.0) * 100) / 100
    }
}
