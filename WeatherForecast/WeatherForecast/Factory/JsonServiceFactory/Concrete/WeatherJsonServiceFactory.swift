//
//  WeatherIconImageServiceFactory.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

class WeatherJsonServiceFactory: JsonServiceFactory {
    func createJsonService() -> JsonService {
        return WeatherJsonService()
    }
}
