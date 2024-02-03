//
//  City.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import Foundation


struct City {
    let name: Name?
    let sunrise: Time
    let sunset: Time
}

struct Name {
    let value: String?
    
    init?(_ value: String) {
        if value.isEmpty {
            return nil
        }
        
        self.value = value
    }
}

struct Time: CustomStringConvertible {
    let value: String
    
    init(_ interval: TimeInterval, dateFormatter: DateFormatter) {
        let date = Date(timeIntervalSince1970: interval)
        self.value = dateFormatter.string(from: date)
    }
    
    var description: String {
        value
    }
}
