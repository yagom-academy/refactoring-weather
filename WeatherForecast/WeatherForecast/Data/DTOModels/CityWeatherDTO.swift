//
//  CityWeather.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class CityWeatherDTO: Decodable {
    let weatherForecast: [WeatherForecastInfoDTO]
    let city: CityDTO
    
    func toDomain() -> CityWeather {
        let weathers = weatherForecast.map { $0.toDomain() }
        let city = city.toDomain()
        return CityWeather(weathers: weathers, city: city)
    }
}
