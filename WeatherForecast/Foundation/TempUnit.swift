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
}
struct Metric: TempUnit {
    var expression: String = "℉"
    var expressionTitle: String = "화씨"
}

struct Imperial: TempUnit {
    var expression: String = "℃"
    var expressionTitle: String = "섭씨"
}
