//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/17/24.
//

import Foundation

extension DateFormatter {
    static let krDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
}
