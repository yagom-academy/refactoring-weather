//
//  WeatherForecaseInfo.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - List
struct WeatherForecastInfo: Decodable {
    private(set) var dt: TimeInterval
    private let main: MainInfo
    private let weather: Weather
    private let dtTxt: String
    
    var date: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        
        return formatter.string(from: Date(timeIntervalSince1970: dt))
    }
    
    var weatherMain: String { weather.main }
    var description: String { weather.description }
    
    var temp: Double { main.temp }
    var tempMax: Double { main.tempMax }
    var tempMin: Double { main.tempMin }
    var feelsLike: Double { main.feelsLike }
    
    var pop: String { "\(main.pop * 100)%" }
    var humidity: String { "\(main.humidity)%" }
    
    var iconName: String { weather.icon }
}
