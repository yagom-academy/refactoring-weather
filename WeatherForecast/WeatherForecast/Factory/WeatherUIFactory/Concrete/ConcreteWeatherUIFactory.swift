//
//  ConcreteWeatherUIFactory.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

final class ConcreteWeatherUIFactory: WeatherUIFactory {
    func createMainWeatherListView() -> MainWeatherListView {
        let weatherJsonService = WeatherJsonServiceFactory().createJsonService()
        return MainWeatherListView(weatherJsonService: weatherJsonService)
    }
    
    func createMainWeatherListViewController() -> MainWeatherListViewController {
        return MainWeatherListViewController(mainWeatherListView: self.createMainWeatherListView())
    }
    
    
}
