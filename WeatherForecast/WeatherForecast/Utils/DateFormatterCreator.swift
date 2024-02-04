//
//  DateFormatterCreator.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/4/24.
//

import Foundation

struct DateFormatterCreator {
    enum LocaleIndeitifier {
        static let korean: String = "ko_KR"
    }
    
    enum DateFormat {
        static let fullDatetime: String = "yyyy-MM-dd(EEEEE) a HH:mm"
    }
    
    static func createKoreanDateFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocaleIndeitifier.korean)
        dateFormatter.dateFormat = DateFormat.fullDatetime
        return dateFormatter
    }
}
