//
//  WeatherInfo.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

final class WeatherInfo: WeatherInfoCoordinator {
    private var weatherJSON: WeatherJSON?
    private(set) var tempUnit: TempUnit
    
    var weatherJson: WeatherJSON? {
        get {
            weatherJSON
        }
        set {
            weatherJSON = newValue
        }
    }
    
    var weatherForecastInfo: [WeatherForecastInfo]? { weatherJSON?.weatherForecast }
    var tempExpressionTitle: String { tempUnit.expressionTitle}
    var cityInfo: City? { weatherJSON?.city }
    
    init(weatherJSON: WeatherJSON? = nil, tempUnit: TempUnit) {
        self.weatherJSON = weatherJSON
        self.tempUnit = tempUnit
    }
    
    func getWeatherForecastInfo(at index: Int) -> WeatherForecastInfo? {
        guard let weatherForecast = weatherJSON?.weatherForecast,
              index < weatherForecast.count else {
            return nil
        }
        
        return weatherJSON?.weatherForecast[index]
    }
       
    func getTemp(at index: Int) -> String? {
        guard let weatherForecastInfo = getWeatherForecastInfo(at: index) else { return nil }
        return tempUnit.formattedTemp(weatherForecastInfo.temp)
    }
     
    func toggleTempUnit() {
        if tempUnit is Fahrenheit {
            tempUnit = Celsius()
            return
        }
        tempUnit = Fahrenheit()
    }
}
