//
//  WeatherDetailInfoCoordinator.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

protocol WeatherDetailInfoCoordinator {
    var sunrise: String { get }
    var sunset: String { get }
    func getWeather() -> String
    func getDescription() -> String
    func getTemp() -> String
    func getTempMax() -> String
    func getTempMin() -> String
    func getFeelsLike() -> String
    func getTempUnitExpression() -> String
    func getPop() -> String
    func getHumidity() -> String
    func getIconName() -> String
}
