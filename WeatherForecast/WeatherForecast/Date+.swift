//
//  Date+.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/19/24.
//

import Foundation

extension Date {
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    private static func fetchFormatter(_ format: String?) -> DateFormatter {
        let formatter = Date.formatter
        formatter.dateFormat = format
        return formatter
    }
    
    public static func string(from date: Foundation.Date, format: String = "") -> String? {
        fetchFormatter(format).string(from: date)
    }
    
    public static func string(from date: Foundation.Date, style: DateFormatter.Style) -> String {
        let formatter = fetchFormatter(.none)
        formatter.timeStyle = style
        return formatter.string(from: date)
    }
}
