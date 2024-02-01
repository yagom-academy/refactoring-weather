//
//  JsonServiceable.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

protocol JsonServiceable {
    func fetchWeatherJSON() -> Result<WeatherJSON, Error>
}
