//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - Temperature Unit
protocol TempUnit {
    var expression: String { get }
    var expressionTitle: String { get }
    func convertTemp(temp: Double) -> String
}
