//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by 구민영 on 3/19/24.
//

import Foundation

protocol TempUnitProtocol {
    var expression: String { get }
    var textKR: String { get }
    func applyTempUnit(temp: Double) -> Double
}

extension TempUnitProtocol {
    func toggle() -> TempUnitProtocol {
        if self is Metric {
            return Imperial()
        } else {
            return Metric()
        }
    }
}

struct Metric: TempUnitProtocol {
    var expression: String = "℃"
    var textKR: String = "섭씨"
    func applyTempUnit(temp: Double) -> Double {
        return temp
    }
}

struct Imperial: TempUnitProtocol {
    var expression: String = "℉"
    var textKR: String = "화씨"
    func applyTempUnit(temp: Double) -> Double {
        return temp * 1.8 + 32.0
    }
}

struct Shared {
    static var tempUnit: TempUnitProtocol = Metric()
}
