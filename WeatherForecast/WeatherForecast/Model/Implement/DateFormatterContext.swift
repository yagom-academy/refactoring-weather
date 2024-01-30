//
//  DateFormatterContext.swift
//  WeatherForecast
//
//  Created by hyosung on 1/31/24.
//

import Foundation

struct DateFormatterContext: DateFormatterContextService {
  private var strategy: DateFormatterStrategy

  init(strategy: DateFormatterStrategy) {
      self.strategy = strategy
  }
}

extension DateFormatterContext {
  func string(from: TimeInterval) -> String {
    return strategy.string(from: from)
  }
}
