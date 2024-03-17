//
//  DateFormat.swift
//  WeatherForecast
//
//  Created by Mac on 2024/03/16.
//

import Foundation

extension DateFormatter {
    static func localizedDateFormatter() -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }
}
