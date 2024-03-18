//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather UI Model
struct FetchWeatherResult {
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
struct WeatherForecastInfo {
    private let date: Date
    private let main: MainInfo
    private let weather: Weather
    
    init(date: Date, main: MainInfo, weather: Weather) {
        self.date = date
        self.main = main
        self.weather = weather
    }
    
    init(dto: WeatherForecastInfoDTO) {
        self.date = .init(timeIntervalSince1970: dto.dt)
        self.main = .init(dto: dto.main)
        self.weather = .init(dto: dto.weather)
    }
    
    var mainString: String {
        weather.main.rawValue
    }
    
    var description: String {
        weather.description
    }
    
    var dateString: String {
        date.weatherDateString
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
struct MainInfo {
    let temp, feelsLike, tempMin, tempMax: Double
    let humidity, pop: Double
    
    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, humidity: Double, pop: Double) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.humidity = humidity
        self.pop = pop
    }
    
    init(dto: MainInfoDTO) {
        self.temp = dto.temp
        self.feelsLike = dto.feelsLike
        self.tempMin = dto.tempMin
        self.tempMax = dto.tempMax
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

struct Weather {
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

// MARK: - City

struct City {
    private let id: Int
    private let name: String
    private let country: CityCountry
    private let sunrise, sunset: Date
    
    init(id: Int, name: String, country: CityCountry, sunrise: Date, sunset: Date) {
        self.id = id
        self.name = name
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    init(dto: CityDTO) {
        self.id = dto.id
        self.name = dto.name
        self.country = CityCountry(rawValue: dto.country) ?? .us
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
