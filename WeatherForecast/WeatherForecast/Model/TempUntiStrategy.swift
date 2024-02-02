//
//  TempUntiStrategy.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/2/24.
//

import Foundation

protocol TempUnitStrategy {
    var expression: String { get }
    var expressionText: String { get }
    
    func convert(temp: Double) -> Double
}


struct CelsiusStrategy: TempUnitStrategy {
    private(set) var expression: String = "℃"
    private(set) var expressionText: String = "섭씨"
    
    func convert(temp: Double) -> Double {
        return temp * 1.8 + 32
    }
}


struct FahrenheitStrategy: TempUnitStrategy {
    private(set) var expression: String = "℉"
    private(set) var expressionText: String = "화씨"
    
    func convert(temp: Double) -> Double {
        return (temp - 32) * 1.8
    }
}
