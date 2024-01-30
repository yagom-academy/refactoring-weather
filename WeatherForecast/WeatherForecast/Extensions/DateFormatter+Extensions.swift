//
//  DateFormatter+Extensions.swift
//  WeatherForecast
//
//  Created by hyosung on 1/31/24.
//

import Foundation

extension DateFormatter {
  struct Configuration {
    var locale: DateFormatter.Locale = .KR
    var style: DateFormatter.Style = .none
  }
  
  enum Format {
    case none
    case completeDateAndTime
    
    var style: String {
      switch self {
      case .none: return ""
      case .completeDateAndTime: return "yyyy-MM-dd(EEEEE) a HH:mm"
      }
    }
  }

  enum Locale {
    case KR
    
    var identifier: String {
      switch self {
      case .KR: return "ko_KR"
      }
    }
  }
}
