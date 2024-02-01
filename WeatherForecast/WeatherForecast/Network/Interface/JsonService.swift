//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

protocol JsonService {
    func fetchWeatherJSON() -> Result<WeatherJSON, JsonError>
}
