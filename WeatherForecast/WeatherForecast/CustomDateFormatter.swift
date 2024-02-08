//
//  CustomDateFormatter.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import Foundation

struct CustomDateFormatter: DateFormattable {
    private let dateFormatter: DateFormatter
    
    init(dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm",
         locale: Locale = Locale(identifier: "ko_KR"),
         timeStyle: DateFormatter.Style = .short
    ) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = dateFormat
        self.dateFormatter.locale = locale
        self.dateFormatter.timeStyle = timeStyle
    }
    
    func string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
