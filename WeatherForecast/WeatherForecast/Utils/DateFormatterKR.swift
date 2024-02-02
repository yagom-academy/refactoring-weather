//
//  DateFormatterKR.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

struct DateFormatterKR {
    private let dateFormatter: DateFormatter = DateFormatter()
    private let dateFormat: String
    
    init(dateFormat: String) {
        self.dateFormat = dateFormat
        dateFormatter.locale = .init(identifier: "ko_KR")
    }
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
