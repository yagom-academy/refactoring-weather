//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/20/24.
//

import Foundation

protocol TempUnit {
    var expression: String { get }
    var buttonTitle: String { get }
}

struct Metric: TempUnit {
    var expression: String { "℃" }
    var buttonTitle: String { "섭씨" }
}

struct Imperial: TempUnit {
    var expression: String { "℉" }
    var buttonTitle: String { "화씨" }
}
