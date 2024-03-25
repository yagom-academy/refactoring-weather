//
//  WeatherDTO.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import Foundation

// MARK: - Weather DTO
struct FetchWeatherResultDTO: Decodable {
    let weatherForecast: [WeatherForecastInfoDTO]
    let city: CityDTO
    
    static var stub: Self {
        .init(weatherForecast: [.stub], city: .stub)
    }
}

// MARK: - List
struct WeatherForecastInfoDTO: Decodable {
    let dt: TimeInterval
    let main: MainInfoDTO
    let weather: WeatherDTO
    let dtTxt: String
    
    static var stub: Self {
        .init(dt: 1705557600, main: .stub, weather: .stub, dtTxt: "2024-01-18 06:00:00")
    }
}

// MARK: - MainClass
struct MainInfoDTO: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
    
    static var stub: Self {
        .init(temp: 5.01, feelsLike: 3.55, tempMin: 5.01, tempMax: 6.24, pressure: 1023, seaLevel: 1023, grndLevel: 1016, humidity: 87, pop: 0)
    }
}

// MARK: - Weather
enum WeatherIcon: String, Decodable {
    case n4 = "04n"
    case d4 = "04d"
    case n10 = "10n"
    case d10 = "10d"
    case n13 = "13n"
    case d13 = "13d"
}

struct WeatherDTO: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: WeatherIcon
    
    static var stub: Self {
        .init(id: 804, main: "Clouds", description: "overcast clouds", icon: .d4)
    }
}

// MARK: - City
enum CityCountry: String, Decodable {
    case korea = "KR"
    case us = "US"
}

struct CityDTO: Decodable {
    let id: Int
    let name: String
    let coord: CoordDTO
    let country: CityCountry
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
    
    static var stub: Self {
        .init(id: 1845604, name: "Cheongju-si", coord: .stub, country: .korea, population: 634596, timezone: 32400, sunrise: 1705531242, sunset: 1705567148)
    }
}

// MARK: - Coord
struct CoordDTO: Decodable {
    let lat, lon: Double
    
    static var stub: Self {
        .init(lat: 36.6424, lon: 127.489)
    }
}
