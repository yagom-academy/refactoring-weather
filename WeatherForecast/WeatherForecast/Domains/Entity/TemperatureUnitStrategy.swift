//
//  TemperatureUnitStrategy.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/20/24.
//

import Foundation

protocol TemperatureUnitStrategy {
  var title: String { get }
  func convert(temperature: Double) -> String
}

struct Celsius: TemperatureUnitStrategy {
  let title: String = "섭씨"
  
  func convert(temperature: Double) -> String {
    return "\(temperature)℃"
  }
}

struct Fahrenheit: TemperatureUnitStrategy {
  let title: String = "화씨"
  
  func convert(temperature: Double) -> String {
    return "\(temperature)℉"
  }
}
