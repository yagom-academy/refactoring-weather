//
//  Extensions.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
