//
//  DateFormatType.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/12/24.
//

import Foundation

protocol DateFormattable {
  func dateFormat(from timeInterval: TimeInterval, with format: DateFormatType) -> String
}
 
extension DateFormattable {
  func dateFormat(from timeInterval: TimeInterval, with format: DateFormatType) -> String {
    let date: Date = .init(timeIntervalSince1970: timeInterval)
    return format.formatter.string(from: date)
  }
}

enum DateFormatType {
  case KoreanLongForm
  case KoreanShortForm
  
  fileprivate var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    
    switch self {
    case .KoreanLongForm:
      formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    case .KoreanShortForm:
      formatter.dateFormat = .none
      formatter.timeStyle = .short
    }
    
    return formatter
  }
}
