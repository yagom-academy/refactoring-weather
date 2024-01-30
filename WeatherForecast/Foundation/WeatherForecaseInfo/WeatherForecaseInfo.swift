//
//  WeatherForecaseInfo.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - List
struct WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
    var date: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        
        return formatter.string(from: Date(timeIntervalSince1970: dt))
    }
    
    func getWeather() -> String {
        return weather.main
    }
    
    func getDescription() -> String {
        return weather.description
    }
    
    func getTemp() -> Double {
        return main.temp
    }
    
    func getTempMax() -> Double {
        return main.tempMax
    }
    
    func getTempMin() -> Double {
        return main.tempMin
    }
    
    func getFeelsLike() -> Double {
        return main.feelsLike
    }
    
    func getPop() -> String {
        return "\(main.pop * 100)%"
    }
    
    func getHumidity() -> String {
        return "\(main.humidity)%"
    }
    
    func getIconName() -> String {
        return weather.icon
    }
}
