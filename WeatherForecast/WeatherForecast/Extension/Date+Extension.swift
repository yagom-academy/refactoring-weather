//
//  Date+Extension.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/31/24.
//

import Foundation

extension Date {
    func toString(type: DateFormatType, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.timeStyle = timeStyle
        formatter.dateFormat = type.format
        
        return formatter.string(from: self)
    }
}
