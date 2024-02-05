//
//  DateFormatterCache.swift
//  WeatherForecast
//
//  Created by hyosung on 1/30/24.
//

import Foundation

final class DateFormatterCache {
  static let shared = DateFormatterCache()
  private var cachedFormatter: NSCache<NSString, DateFormatter> = NSCache()
  
  private init() { }
}

extension DateFormatterCache {
  func formatter(
    withFormat format: String,
    configuration: DateFormatter.Configuration = .init(
      locale: .KR,
      style: .none
    )
  ) -> DateFormatter {
    if let cachedFormatter = cachedFormatter.object(forKey: format as NSString) {
      return cachedFormatter
    } else {
      let newFormatter = DateFormatter()
      newFormatter.dateFormat = format
      if configuration.style != .none { 
        newFormatter.timeStyle = configuration.style
      }
      newFormatter.locale = .init(identifier: configuration.locale.identifier)
      cachedFormatter.setObject(
        newFormatter, forKey:
          format as NSString
      )
      return newFormatter
    }
  }
}
