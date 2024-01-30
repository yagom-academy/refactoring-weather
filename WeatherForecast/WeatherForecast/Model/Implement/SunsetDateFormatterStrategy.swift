//
//  SunsetDateFormatterStrategy.swift
//  WeatherForecast
//
//  Created by hyosung on 1/31/24.
//

import Foundation

struct SunsetDateFormatterStrategy: DateFormatterStrategy {
  private let dateFormatter: DateFormatter
  private let locale: DateFormatter.Locale = .KR
  private let style: DateFormatter.Style = .short
  private let dateFormat: DateFormatter.Format = .none
  
  init() {
    dateFormatter = DateFormatterCache.shared.formatter(
      withFormat: dateFormat.style,
      configuration: .init(
        locale: locale,
        style: style
      )
    )
  }
}

extension SunsetDateFormatterStrategy {
  func string(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    return dateFormatter.string(from: date)
  }
}
