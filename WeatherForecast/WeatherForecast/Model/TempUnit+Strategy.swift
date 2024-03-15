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
    
    private var strategy: TempUnitStrategy {
        switch(self) {
        case .metric:
            return MetricUnitStrategy()
        case .imperial:
            return ImperialUnitStrategy()
        }
    }
    
    func convertUnit(fromMetric metric: Double) -> Double {
        self.strategy.convertTemperture(metric: metric)
    }
    
    var unitTitle: String { get { return strategy.title }}
    var unitSymbol: String { get { return strategy.unitSymbol }}
}

protocol TempUnitStrategy {
    var title: String { get }
    var unitSymbol: String { get }
    
    func convertTemperture(metric: Double) -> Double
}

final class MetricUnitStrategy: TempUnitStrategy {
    var title: String = "섭씨"
    var unitSymbol: String = "℃"
    
    func convertTemperture(metric: Double) -> Double {
        return metric
    }
}

final class ImperialUnitStrategy: TempUnitStrategy {
    var title: String = "화씨"
    var unitSymbol: String = "℉"
    
    func convertTemperture(metric: Double) -> Double {
        return round((metric * 5.0 / 9.0 + 32.0) * 100) / 100
    }
}
