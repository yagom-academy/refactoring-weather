//
//  Extension+Date.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import Foundation

extension Date {
    
    /// Returns String with "yyyy-MM-dd(EEEEE) a HH:mm" format in "ko_KR" locale
    func formattedString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter.string(from: self)
    }
}
