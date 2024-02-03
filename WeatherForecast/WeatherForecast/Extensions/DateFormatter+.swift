//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/2/24.
//

import Foundation


extension DateFormatter {
    static let `default`: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    static let city: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
}
