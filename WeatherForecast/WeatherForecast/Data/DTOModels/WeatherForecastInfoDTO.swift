//
//  WeatherForecastInfo.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class WeatherForecastInfoDTO: Decodable {
    let dt: TimeInterval
    let main: MainInfoDTO
    let weather: WeatherDTO
    let dtTxt: String
    
    func toDomain() -> Weather {
        let temperature: Temperature = Temperature(
            current: main.temp,
            feelsLike: main.feelsLike,
            min: main.tempMin,
            max: main.tempMax
        )
        let weatherCondition: WeatherCondition = WeatherCondition(
            main: weather.main,
            description: weather.description,
            icon: weather.icon
        )
        return Weather(
            date: Date(timeIntervalSince1970: self.dt),
            temperature: temperature,
            weatherCondition: weatherCondition,
            humidity: self.main.humidity,
            pop: self.main.pop
        )
    }
}

