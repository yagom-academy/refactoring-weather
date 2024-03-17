//
//  Date+.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/17/24.
//

import Foundation

extension Date {
  func formatted(using formatter: DateFormatter) -> String {
    return formatter.string(from: self)
  }
}

extension DateFormatter {
  static let koreanLongForm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    return formatter
  }()
  
  static let koreanShortForm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = .none
    formatter.timeStyle = .short
    return formatter
  }()
}
