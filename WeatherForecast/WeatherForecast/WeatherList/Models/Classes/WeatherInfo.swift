//
//  WeatherInfo.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

final class WeatherInfo: WeatherInfoCoordinator {
    var weatherJSON: WeatherJSON?
    var tempUnit: TempUnit
    var weatherForecastInfo: [WeatherForecastInfo]? {
        return weatherJSON?.weatherForecast
    }
    
    init(weatherJSON: WeatherJSON? = nil, tempUnit: TempUnit) {
        self.weatherJSON = weatherJSON
        self.tempUnit = tempUnit
    }
    
    func setWeatherJSON(json: WeatherJSON) {
        self.weatherJSON = json
    }
    
    func getWeatherForecastInfo(at index: Int) -> WeatherForecastInfo? {
        guard let weatherForecast = weatherJSON?.weatherForecast,
              index < weatherForecast.count else {
            return nil
        }
        
        return weatherJSON?.weatherForecast[index]
    }
    
    func getCityInfo() -> City? {
        return weatherJSON?.city
    }
    
    func getTempUnit() -> TempUnit {
        return tempUnit
    }
        
    func getTemp(at index: Int) -> String? {
        guard let weatherForecastInfo = getWeatherForecastInfo(at: index) else { return nil }
        return "\(weatherForecastInfo.getTemp())\(tempUnit.expression)"
    }
    
    func getTempExpressionTitle() -> String {
        return tempUnit.expressionTitle
    }
    
    func toggleTempUnit() {
        if tempUnit is Metric {
            tempUnit = Imperial()
            return
        }
        tempUnit = Metric()
    }
}
