//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import Foundation

// MARK: - Weather JSON Format
struct WeatherJSON: Decodable {
  let weatherForecast: [WeatherForecastInfo]
  let city: City
}

// MARK: - List
struct WeatherForecastInfo: Decodable {
  let dateTime: TimeInterval
  let main: MainInfo
  let weather: Weather
  let dateText: String
  
  enum CodingKeys: String, CodingKey {
    case dateTime = "dt"
    case main
    case weather
    case dateText = "dtTxt"
  }
}

// MARK: - MainClass
struct MainInfo: Decodable {
  let temperature: Double
  let windChillTemperature: Double
  let lowestTemperature: Double
  let highestTemperature: Double
  let pressure: Double
  let seaLevel: Double
  let grndLevel: Double
  let humidity: Double
  let pop: Double
  
  enum CodingKeys: String, CodingKey {
    case temperature = "temp"
    case windChillTemperature = "feelsLike"
    case lowestTemperature = "tempMin"
    case highestTemperature = "tempMax"
    case pressure
    case seaLevel
    case grndLevel
    case humidity
    case pop
  }
}

// MARK: - Weather
struct Weather: Decodable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}

// MARK: - City
struct City: Decodable {
  let id: Int
  let name: String
  let coordinates: Coordinates
  let country: String
  let population: Int
  let timezone: Int
  let sunriseTime: TimeInterval
  let sunsetTime: TimeInterval
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case coordinates = "coord"
    case country
    case population
    case timezone
    case sunriseTime = "sunrise"
    case sunsetTime = "sunset"
  }
}

// MARK: - Coordinates
struct Coordinates: Decodable {
  let latitude: Double
  let longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lon"
  }
}

// MARK: - Temperature Unit
enum TemperatureUnit: String {
  case celsius
  case fahrenheit
  
  var symbol: String {
    switch self {
    case .celsius: return "℃"
    case .fahrenheit: return "℉"
    }
  }
  
  var title: String {
    switch self {
    case .celsius:
      return "섭씨"
    case .fahrenheit:
      return "화씨"
    }
  }
}

