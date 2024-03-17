//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/12/24.
//

import Foundation

extension Date {
    func toFormattedString(_ dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm") -> String? {
        DateFormatter.krDateFormatter.dateFormat = dateFormat
        return DateFormatter.krDateFormatter.string(from: self)
    }
}
