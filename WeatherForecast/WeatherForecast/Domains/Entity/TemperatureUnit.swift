//
//  TemperatureUnit.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/20/24.
//

import Foundation

enum TemperatureUnit: String {
  case celsius
  case fahrenheit
  
  var strategy: TemperatureUnitStrategy {
    switch self {
    case .celsius:
      return Celsius()
    case .fahrenheit:
      return Fahrenheit()
    }
  }
  
  mutating func toggle() {
    if self == .celsius {
      self = .fahrenheit
      return
    }
    self = .celsius
  }
}
