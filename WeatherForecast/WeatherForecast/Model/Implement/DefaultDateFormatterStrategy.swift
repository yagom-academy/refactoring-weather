//
//  DefaultDateFormatterStrategy.swift
//  WeatherForecast
//
//  Created by hyosung on 1/31/24.
//

import Foundation

struct DefaultDateFormatterStrategy: DateFormatterStrategy {
  private let dateFormatter: DateFormatter
  private let locale: DateFormatter.Locale = .KR
  private let dateFormat: DateFormatter.Format = .completeDateAndTime
  
  init() {
    dateFormatter = DateFormatterCache.shared.formatter(
      withFormat: dateFormat.style,
      configuration: .init(
        locale: locale,
        style: .none
      )
    )
  }
}

extension DefaultDateFormatterStrategy {
  func string(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    return dateFormatter.string(from: date)
  }
}
