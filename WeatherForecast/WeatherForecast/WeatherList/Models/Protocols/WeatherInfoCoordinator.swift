//
//  WeatherInfoCoordinator.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

protocol WeatherInfoCoordinator {
    var tempUnit: TempUnit { get }
    var weatherForecastInfo: [WeatherForecastInfo]? { get }
    func setWeatherJSON(json: WeatherJSON)
    func getCityInfo() -> City?
    func getWeatherForecastInfo(at index: Int) -> WeatherForecastInfo?
    func getTempUnit() -> TempUnit
    func getTemp(at index: Int) -> String?
    func toggleTempUnit()
    func getTempExpressionTitle() -> String
}
