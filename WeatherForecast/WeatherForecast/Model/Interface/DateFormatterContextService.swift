//
//  DateFormatterContextService.swift
//  WeatherForecast
//
//  Created by hyosung on 1/31/24.
//

import Foundation

protocol DateFormatterContextService {
  init(strategy: DateFormatterStrategy)
  func string(from: TimeInterval) -> String
}
