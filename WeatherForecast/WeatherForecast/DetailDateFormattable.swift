//
//  DetailDateFormattable.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/4/24.
//

import Foundation

protocol DetailDateFormattable: AnyObject {
    
}

extension DetailDateFormattable {
    var detailDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }
}
