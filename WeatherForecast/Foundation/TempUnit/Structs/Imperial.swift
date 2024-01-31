//
//  Imperial.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

struct Imperial: TempUnit {
    private(set) var expression: String = "℃"
    private(set) var expressionTitle: String = "섭씨"
}
