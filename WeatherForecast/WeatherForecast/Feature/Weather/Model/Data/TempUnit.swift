//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/14/24.
//

import Foundation

protocol TemperatureStrategy {
    var krString: String { get }
    func convert(_ temperature: Double) -> String
}

struct MetricStrategy: TemperatureStrategy {
    var krString: String {
        "섭씨"
    }
    
    func convert(_ temperature: Double) -> String {
        "\(temperature)℃"
    }
}

struct ImperialStrategy: TemperatureStrategy {
    var krString: String {
        "화씨"
    }
    
    /// 화씨 변환: (a × 9/5) + 32
    func convert(_ temperature: Double) -> String {
        let convertedTemperature: Double = round(((temperature * 9 / 5) + 32) * 100) / 100
        
        return "\(convertedTemperature)℉"
    }
}

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    
    private var strategy: TemperatureStrategy {
        switch self {
        case .metric:
            MetricStrategy()
        case .imperial:
            ImperialStrategy()
        }
    }
    
    var krString: String {
        strategy.krString
    }
    
    func convert(_ temperature: Double) -> String {
        strategy.convert(temperature)
    }
}
