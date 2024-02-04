//
//  WeatherUIFactory.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

protocol WeatherUIFactory {
    func createMainWeatherListView() -> MainWeatherListView
    func createMainWeatherListViewController() -> MainWeatherListViewController
}
