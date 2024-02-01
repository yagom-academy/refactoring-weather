//
//  Fahrenheit.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

struct Fahrenheit: TempUnit {
    private(set) var expression: String = "℉"
    private(set) var expressionTitle: String = "화씨"
    func convertTemp(temp: Double) -> String {
        let formattedTemp = String(format: "%.2f", (temp * 1.8) + 32)
        return "\(formattedTemp)\(expression)"
    }
}
