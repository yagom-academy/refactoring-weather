//
//  CityInfo.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/7/24.
//

import Foundation

final class CityInfo {
    
    private var city: City
    private var formatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }
            
    
    init(city: City) {
        self.city = city
    }
    
    var currentCity: String {
        return city.name
    }
    
    var sunriseTime: String {
        let date = Date(timeIntervalSince1970: city.sunrise)
        return "일출 : \(formatter.string(from: date))"
    }
    
    var sunsetTime: String {
        let date = Date(timeIntervalSince1970: city.sunset)
        return "일몰 : \(formatter.string(from: date))"
    }
}
