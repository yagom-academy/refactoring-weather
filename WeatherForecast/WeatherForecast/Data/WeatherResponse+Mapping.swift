//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
struct WeatherJsonDTO: Decodable {
    let weatherForecast: [WeatherForecastInfoDTO]
    let city: CityDTO
}

// MARK: - List
struct WeatherForecastInfoDTO: Decodable {
    let dt: TimeInterval
    let main: MainInfoDTO
    let weather: WeatherDTO
    let dtTxt: String
}

// MARK: - MainClass
struct MainInfoDTO: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
struct WeatherDTO: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - City
struct CityDTO: Decodable {
    let id: Int
    let name: String
    let coord: CoordinateDTO
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coord
struct CoordinateDTO: Decodable {
    let lat, lon: Double
}

// MARK: - Mapping to domain
extension WeatherJsonDTO {
    func toDomain(tempUnit: TempUnit) -> WeatherList {
        .init(
            weatherForecast: weatherForecast.map { $0.toDomain(tempUnit: tempUnit) },
            city: city.toDomain()
        )
    }
}

extension WeatherForecastInfoDTO {
    func toDomain(tempUnit: TempUnit) -> WeatherForecast {
        .init(
            title: Name(weather.main),
            description: Name(weather.description),
            temp: Temperature(main.temp, tempUnit: tempUnit),
            feelsLike: Temperature(main.feelsLike, tempUnit: tempUnit),
            tempMax: Temperature(main.tempMax, tempUnit: tempUnit),
            tempMin: Temperature(main.tempMin, tempUnit: tempUnit),
            pop: Probability(main.pop * 100),
            humidity: Probability(main.humidity),
            iconUrl: WeatherIcon(weather.icon),
            updatedDate: Time(dt, dateFormatter: .default)
        )
    }
}

extension CityDTO {
    func toDomain() -> City {
        .init(
            name: Name(name),
            sunrise: Time(sunrise, dateFormatter: .city),
            sunset: Time(sunset, dateFormatter: .city)
        )
    }
}
