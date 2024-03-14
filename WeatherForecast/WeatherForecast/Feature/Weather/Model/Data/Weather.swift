//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
class FetchWeatherResult {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
    
    init(weatherForecast: [WeatherForecastInfo], city: City) {
        self.weatherForecast = weatherForecast
        self.city = city
    }
    
    init(dto: FetchWeatherResultDTO) {
        self.weatherForecast = dto.weatherForecast.map({ .init(dto: $0) })
        self.city = .init(dto: dto.city)
    }
}

// MARK: - List
class WeatherForecastInfo {
    let dt: Date
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
    
    init(dt: Date, main: MainInfo, weather: Weather, dtTxt: String) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.dtTxt = dtTxt
    }
    
    init(dto: WeatherForecastInfoDTO) {
        self.dt = .init(timeIntervalSince1970: dto.dt)
        self.main = .init(dto: dto.main)
        self.weather = .init(dto: dto.weather)
        self.dtTxt = dto.dtTxt
    }
    
    var mainString: String {
        weather.main.rawValue
    }
    
    var description: String {
        weather.description
    }
    
    var dateString: String {
        dt.weatherDateString
    }
    
    var temperature: Double {
        main.temp
    }
    
    var feelsLike: Double {
        main.feelsLike
    }
    
    var minimumTemperature: Double {
        main.tempMin
    }
    
    var maximumTemperature: Double {
        main.tempMax
    }
    
    var rainProbabilityString: String {
        "\(main.pop * 100)%"
    }
    
    var humidityString: String {
        "\(main.humidity)%"
    }
    
    var iconUrlString: String {
        "https://openweathermap.org/img/wn/\(weather.icon)@2x.png"
    }
}

// MARK: - MainClass
class MainInfo {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
    
    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Double, seaLevel: Double, grndLevel: Double, humidity: Double, pop: Double) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.humidity = humidity
        self.pop = pop
    }
    
    init(dto: MainInfoDTO) {
        self.temp = dto.temp
        self.feelsLike = dto.feelsLike
        self.tempMin = dto.tempMin
        self.tempMax = dto.tempMax
        self.pressure = dto.pressure
        self.seaLevel = dto.seaLevel
        self.grndLevel = dto.grndLevel
        self.humidity = dto.humidity
        self.pop = dto.pop
    }
}

// MARK: - Weather
enum WeatherMain: String {
    case sunny = "Sunny"
    case rain = "Rain"
    case clouds = "Clouds"
    case snow = "Snow"
}

class Weather {
    let id: Int
    let main: WeatherMain
    let description: String
    let icon: String
    
    init(id: Int, main: WeatherMain, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    init(dto: WeatherDTO) {
        self.id = dto.id
        self.main = WeatherMain(rawValue: dto.main) ?? .sunny
        self.description = dto.description
        self.icon = dto.icon
    }
}

enum CityCountry: String {
    case korea = "KR"
    case us = "US"
}

// MARK: - City
class City {
    let id: Int
    let name: String
    let coord: Coord
    let country: CityCountry
    let population, timezone: Int
    let sunrise, sunset: Date
    
    init(id: Int, name: String, coord: Coord, country: CityCountry, population: Int, timezone: Int, sunrise: Date, sunset: Date) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    init(dto: CityDTO) {
        self.id = dto.id
        self.name = dto.name
        self.coord = .init(dto: dto.coord)
        self.country = CityCountry(rawValue: dto.country) ?? .us
        self.population = dto.population
        self.timezone = dto.timezone
        self.sunrise = .init(timeIntervalSince1970: dto.sunrise)
        self.sunset = .init(timeIntervalSince1970: dto.sunset)
    }
    
    var sunriseString: String {
        sunrise.citySunriseString
    }
    
    var sunsetString: String {
        sunset.citySunsetString
    }
}

// MARK: - Coord
class Coord {
    let lat, lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    init(dto: CoordDTO) {
        self.lat = dto.lat
        self.lon = dto.lon
    }
}

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    
    private var strategy: TemperatureStrategy {
        switch self {
        case .metric:
            MetricStrategy()
        case .imperial:
            ImperialStrategy()
        }
    }
    
    func convert(_ temperature: Double) -> String {
        strategy.convert(temperature)
    }
}

protocol TemperatureStrategy {
    var krString: String { get }
    func convert(_ temperature: Double) -> String
}

struct MetricStrategy: TemperatureStrategy {
    var krString: String {
        "섭씨"
    }
    
    func convert(_ temperature: Double) -> String {
        "\(temperature)℃"
    }
}

struct ImperialStrategy: TemperatureStrategy {
    var krString: String {
        "화씨"
    }
    
    func convert(_ temperature: Double) -> String {
        // TOOD: 변환
        let convertedTemperature: Double = temperature
        
        return "\(convertedTemperature)℉"
    }
}

