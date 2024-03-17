//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/17/24.
//

import Foundation

enum DateFormatterLocale: String{
    case ko_KR = "ko_KR"
}

extension DateFormatter {
    static let krDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: DateFormatterLocale.ko_KR.rawValue)
        return formatter
    }()
    
    static func getDateFormatter(locale: DateFormatterLocale) -> DateFormatter {
        switch locale {
        case .ko_KR:
            return krDateFormatter
        }
    }
}
