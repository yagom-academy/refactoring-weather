//
//  InfoModel.swift
//  WeatherForecast
//
//  Created by 김정원 on 2/7/24.
//

import Foundation

struct WeatherDetailInfo {
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    var weatherForecast: WeatherForecastInfo
    
    var mainWeather: String {
        return weatherForecast.weather.main
    }
    var description: String {
        return weatherForecast.weather.description
    }
    var date: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: weatherForecast.dt))
    }
    var iconImageUrl: String {
        weatherForecast.weather.icon
    }
    
    init(weatherForecast: WeatherForecastInfo) {
        self.weatherForecast = weatherForecast
    }
}
struct MainDetailInfo {
    
    var mainInfo: MainInfo
    
    var currentTemp: Double {
        return mainInfo.temp
    }
    var feelsLikeTemp: Double {
        return mainInfo.feelsLike
    }
    var maxTemp: Double {
        return mainInfo.tempMax
    }
    var minTemp: Double {
        return mainInfo.tempMin
    }
    var pop: Double {
        return mainInfo.pop
    }
    var humidity: Double {
        return mainInfo.humidity
    }
    
    init(mainInfo: MainInfo){
        self.mainInfo = mainInfo
    }
    
}
struct CityDetailInfo {
    
    let formatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
    
    var city: City
    
    var sunrise: String {
        return "\(formatter.string(from: Date(timeIntervalSince1970: city.sunrise)))"
    }
    var sunset: String {
        return "\(formatter.string(from: Date(timeIntervalSince1970: city.sunset)))"
    }
    init(city: City) {
        self.city = city
    }
}
