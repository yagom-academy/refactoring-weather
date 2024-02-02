//
//  WeatherInfoCoordinator.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

protocol WeatherInfoCoordinator: AnyObject {
    var weatherForecastInfo: [WeatherForecastInfo]? { get }
    var weatherJson: WeatherJSON? { get set }
    
    var tempUnit: TempUnit { get }
    var tempExpressionTitle: String { get }
    
    var cityInfo: City? { get }
    
    func getWeatherForecastInfo(at index: Int) -> WeatherForecastInfo?
    func getTemp(at index: Int) -> String?
    func toggleTempUnit()
}
