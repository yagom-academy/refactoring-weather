//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/20/24.
//

import Foundation

extension DateFormatter {
  static let KRFullFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    return formatter
  }()

  static let KRShortStyle: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = .none
    formatter.timeStyle = .short
    return formatter
  }()
}
