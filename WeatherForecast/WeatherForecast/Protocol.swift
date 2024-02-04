//
//  Protocol.swift
//  WeatherForecast
//
//  Created by 김정원 on 2/4/24.
//

import Foundation

protocol WeatherForeCastDelegate: AnyObject {
    func fetchWeatherInfo() -> WeatherForecastInfo
    func fetchCityInfo() -> City
    func fetchTempUnit() -> TempUnit
}
