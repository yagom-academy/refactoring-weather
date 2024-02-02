//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
struct WeatherJSONDTO: Decodable {
    let weatherForecast: [WeatherForecastInfoDTO]
    let city: CityInfoDTO
    
    func toEntity() -> Weather {
        return .init(
            weatherForecast: weatherForecast.map { (weatherForecast: WeatherForecastInfoDTO) in
                weatherForecast.toEntity()
            },
            city: city.toEntity()
        )
    }
}

// MARK: - List
struct WeatherForecastInfoDTO: Decodable {
    let dt: TimeInterval
    let main: MainInfoDTO
    let weather: WeatherInfoDTO
    let dtTxt: String
    
    func toEntity() -> WeatherForecastInfo {
        return .init(
            dt: dt,
            main: main.toEntity(),
            weather: weather.toEntity(),
            dtTxt: dtTxt
        )
    }
}

// MARK: - MainClass
struct MainInfoDTO: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
    
    func toEntity() -> MainInfo {
        return .init(
            temp: temp,
            feelsLike: feelsLike,
            tempMin: tempMin,
            tempMax: tempMax,
            pressure: pressure,
            seaLevel: seaLevel,
            grndLevel: grndLevel,
            humidity: humidity,
            pop: pop
        )
    }
}

// MARK: - Weather
struct WeatherInfoDTO: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    func toEntity() -> WeatherInfo {
        return .init(
            id: id,
            main: main,
            description: description,
            icon: icon
        )
    }
}

// MARK: - City
struct CityInfoDTO: Decodable {
    let id: Int
    let name: String
    let coord: CoordDTO
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
    
    func toEntity() -> CityInfo {
        return .init(
            id: id,
            name: name,
            coord: coord.toEntity(),
            country: country,
            population: population,
            timezone: timezone,
            sunrise: sunrise,
            sunset: sunset
        )
    }
}

// MARK: - Coord
struct CoordDTO: Decodable {
    let lat, lon: Double
    
    func toEntity() -> Coord {
        return .init(lat: lat, lon: lon)
    }
}
