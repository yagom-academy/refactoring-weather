//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/12/24.
//

import Foundation


extension Date {
    func toFormattedString(_ dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm", locale: DateFormatterLocale = .ko_KR) -> String? {
        let dateFormatter = DateFormatter.getDateFormatter(locale: locale)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
