//
//  Metric.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

struct Metric: TempUnit {
    private(set) var expression: String = "℉"
    private(set) var expressionTitle: String = "화씨"
}
