//
//  WeatherDetailViewControllerModel.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

struct WeatherDetailViewControllerModel {
  struct Dependency {
    let defaultDateFormatter: DateFormatterContextService
    let sunsetDateFormatter: DateFormatterContextService
    let tempUnitManager: TempUnitManagerService
  }
  
  private let dependency: Dependency

  private (set) var dt: String
  private (set) var weatherGroup: String
  private (set) var weatherDescription: String
  private (set) var temperature: String
  private (set) var maximumTemperature: String
  private (set) var minimumTemperature: String
  private (set) var feelsLike: String
  private (set) var pop: String
  private (set) var humidity: String
  private (set) var sunriseTime: String
  private (set) var sunsetTime: String
  private (set) var imageURL: String
  
  init(
    from weatherForecastInfo: WeatherForecastInfo,
    _ cityInfo: City,
    dependency: Dependency
  ) {
    self.dependency = dependency
    self.dt = dependency.defaultDateFormatter.string(from: weatherForecastInfo.dt)
    self.weatherGroup = weatherForecastInfo.weather.main
    self.weatherDescription = weatherForecastInfo.weather.description
    self.temperature = "현재 기온 : \(weatherForecastInfo.main.temp)\(dependency.tempUnitManager.currentValue.expression)"
    self.maximumTemperature = "최고 기온 : \(weatherForecastInfo.main.tempMax)\(dependency.tempUnitManager.currentValue.expression)"
    self.minimumTemperature = "최저 기온 : \(weatherForecastInfo.main.tempMin)\(dependency.tempUnitManager.currentValue.expression)"
    self.feelsLike = "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(dependency.tempUnitManager.currentValue.expression)"
    self.pop = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
    self.humidity = "습도 : \(weatherForecastInfo.main.humidity)%"
    self.sunriseTime = "일출 : \(dependency.sunsetDateFormatter.string(from: cityInfo.sunrise))"
    self.sunsetTime = "일몰 : \(dependency.sunsetDateFormatter.string(from: cityInfo.sunset))"
    let iconName: String = weatherForecastInfo.weather.icon
    self.imageURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
  }
}
