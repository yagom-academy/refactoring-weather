//
//  Date+.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

extension Date {
    func toString(dateFormat: String = DateFormatterKR.defaultFormat, locale: Locale, timezone: TimeZone) -> String {
        let dateFormatterKR = DateFormatterKR(dateFormat: dateFormat)
        return dateFormatterKR.string(from: self)
    }
}
