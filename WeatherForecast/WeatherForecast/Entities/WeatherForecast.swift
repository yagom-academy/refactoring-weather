//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import Foundation


struct WeatherForecast {
    let title: String
    let description: String
    let temp: Temperature
    let feelsLike: Temperature
    let tempMax: Temperature
    let tempMin: Temperature
    let pop: Probability
    let humidity: Probability
    let iconUrl: WeatherIcon
    let updatedDate: Time
}

struct Temperature: CustomStringConvertible {
    let value: String
    
    init(_ celsius: Double, tempUnit: TempUnit) {
        let temperature = tempUnit.convert(celsius: celsius)
        self.value = "\(temperature)\(tempUnit.expression)"
    }
    
    var description: String {
        value
    }
}

struct Probability: CustomStringConvertible {
    let value: String
    
    init(_ percent: Double) {
        self.value = String(format: "%.1f%", percent)
    }
    
    var description: String {
        value
    }
}

struct WeatherIcon {
    let value: String
    
    init(_ iconName: String) {
        self.value = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
}
