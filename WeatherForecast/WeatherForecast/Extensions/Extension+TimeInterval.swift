//
//  Extension+TimeInterval.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import Foundation


extension TimeInterval {
    /// Returns String from TimeInterval with 'dateFormat = .none', 'timeStyle = .short' and "ko_KR" locale
    /// - Return Value  example: "오전 7:40"
    func stringFromTimeInterval() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }
}
