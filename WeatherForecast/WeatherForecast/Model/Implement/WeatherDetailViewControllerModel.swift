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
  private (set) var weatherConditions: [WeatherCondition]
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
    self.weatherConditions = [
      .init(
        title: "현재 기온",
        value: "\(weatherForecastInfo.main.temp)\(dependency.tempUnitManager.currentValue.expression)"
      ),
      .init(
        title: "체감 기온",
        value: "\(weatherForecastInfo.main.feelsLike)\(dependency.tempUnitManager.currentValue.expression)"
      ),
      .init(
        title: "최고 기온",
        value: "\(weatherForecastInfo.main.tempMax)\(dependency.tempUnitManager.currentValue.expression)"
      ),
      .init(
        title: "최저 기온",
        value: "\(weatherForecastInfo.main.tempMin)\(dependency.tempUnitManager.currentValue.expression)"
      ),
      .init(
        title: "강수 확률",
        value: "\(weatherForecastInfo.main.pop * 100)%"
      ),
      .init(
        title: "습도",
        value: "\(weatherForecastInfo.main.humidity)%"
      ),
      .init(
        title: "일출",
        value: "\(dependency.sunsetDateFormatter.string(from: cityInfo.sunrise))"
      ),
      .init(
        title: "일몰",
        value: "\(dependency.sunsetDateFormatter.string(from: cityInfo.sunset))"
      )
    ]
    
    let iconName: String = weatherForecastInfo.weather.icon
    self.imageURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
  }
}
