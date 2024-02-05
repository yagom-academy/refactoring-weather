//
//  WeatherDetailModel.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

struct WeatherDetailModel {
  struct Dependency {
    let defaultDateFormatter: DateFormatterContextService
    let sunsetDateFormatter: DateFormatterContextService
    let tempUnitManager: TempUnitManagerService
  }
  
  private let dependency: Dependency
  
  private (set) var dt: String
  private (set) var weatherSituation: WeatherSituation
  private (set) var weatherConditions: [WeatherCondition]
  
  init(
    from weatherForecastInfo: WeatherForecastInfo,
    _ cityInfo: City,
    dependency: Dependency
  ) {
    self.dependency = dependency
    self.dt = dependency.defaultDateFormatter.string(from: weatherForecastInfo.dt)
    let iconName: String = weatherForecastInfo.weather.icon
    let imageURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    self.weatherSituation = .init(
      weatherGroup: weatherForecastInfo.weather.main,
      weatherDescription: weatherForecastInfo.weather.description,
      imageURL: imageURL
    )
    
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
  }
}
