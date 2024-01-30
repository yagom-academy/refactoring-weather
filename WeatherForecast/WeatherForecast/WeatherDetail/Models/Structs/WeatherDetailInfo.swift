//
//  WeatherDetailInfo.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

struct WeatherDetailInfo: WeatherDetailInfoCoordinator {
    //MARK: - Properties
    private let weatherForecastInfo: WeatherForecastInfo
    private let cityInfo: City
    private let tempUnit: TempUnit
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
    
    var date: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: weatherForecastInfo.dt))
    }
    
    var sunrise: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise))
    }
    
    var sunset: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset))
    }
    
    //MARK: - Init
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
    }
    
    //MARK: - Methods
    func getWeather() -> String {
        return weatherForecastInfo.getWeather()
    }
    
    func getDescription() -> String {
        return weatherForecastInfo.getDescription()
    }
    
    func getTemp() -> String {
        return "\(weatherForecastInfo.getTemp())\(tempUnit.expression)"
    }
    
    func getTempMax() -> String {
        return "\(weatherForecastInfo.getTempMax())\(tempUnit.expression)"
    }
    
    func getTempMin() -> String {
        return "\(weatherForecastInfo.getTempMin())\(tempUnit.expression)"
    }
    
    func getFeelsLike() -> String {
        return "\(weatherForecastInfo.getFeelsLike())\(tempUnit.expression)"
    }
    
    func getTempUnitExpression() -> String {
        return tempUnit.expression
    }
    
    func getPop() -> String {
        return weatherForecastInfo.getPop()
    }
    
    func getHumidity() -> String {
        return weatherForecastInfo.getHumidity()
    }
    
    func getIconName() -> String {
        return weatherForecastInfo.getIconName()
    }
}
