//
//  Date+Extension.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import Foundation

extension Date {
    static let weatherDateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    var weatherDateString: String {
        Self.weatherDateFormatter.string(from: self)
    }
    
    static let citySunTimeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
    
    var citySunriseString: String {
        let sunriseString: String = Self.citySunTimeFormatter.string(from: self)
        
        return "일출 : \(sunriseString))"
    }
    
    var citySunsetString: String {
        let sunsetString: String = Self.citySunTimeFormatter.string(from: self)
        
        return "일몰 : \(sunsetString))"
    }
}
