//
//  WeatherTableViewCellModel.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

struct WeatherTableViewCellModel {
  struct Dependency {
    let defaultDataFormatter: DateFormatterContextService
    let tempUnitManager: TempUnitManagerService
  }
  
  private let dependency: Dependency
  
  private (set) var imageURL: String
  private (set) var date: String
  private (set) var temperature: String
  private (set) var weather: String
  private (set) var description: String
  
  init(
    from weatherForecastInfo: WeatherForecastInfo,
    dependency: Dependency
  ) {
    self.dependency = dependency
    let iconName: String = weatherForecastInfo.weather.icon
    self.imageURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    self.date = dependency.defaultDataFormatter.string(from: weatherForecastInfo.dt)
    self.temperature = "\(weatherForecastInfo.main.temp)\(dependency.tempUnitManager.currentValue.expression)"
    self.weather = weatherForecastInfo.weather.main
    self.description = weatherForecastInfo.weather.description
  }
}
