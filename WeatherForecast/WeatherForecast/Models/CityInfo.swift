//
//  CityInfo.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/7/24.
//

import Foundation

class CityInfo {
    
    private var city: City
    
    init(city: City) {
        self.city = city
    }
    
    var currentCity: String {
        return city.name
    }
    
    var sunriseTime: String {
        return "일출 : \(city.sunrise.stringFromTimeInterval())"
    }
    
    var sunsetTime: String {
        return "일몰 : \(city.sunset.stringFromTimeInterval())"
    }
}
