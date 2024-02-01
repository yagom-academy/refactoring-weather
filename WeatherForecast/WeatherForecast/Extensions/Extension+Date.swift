//
//  Extension+Date.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import Foundation

extension Date {
    
    /// Returns String in "ko_KR" locale formatted as  "yyyy-MM-dd(EEEEE) a HH:mm"
    /// - Return Value  example: "2024-01-20(토) 오전 7:40"
    func formattedStringFromDate() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter.string(from: self)
    }
}
