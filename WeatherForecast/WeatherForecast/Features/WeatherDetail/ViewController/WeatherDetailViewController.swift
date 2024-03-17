//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

struct WeatherDetailInfo {
  let weatherForecastInfo: WeatherForecastInfo?
  let cityInfo: City?
  let temperatureUnit: TemperatureUnit
}

final class WeatherDetailViewController: UIViewController {
  private let weatherImageCacheService: WeatherImageCacheServiceable
  private var info: WeatherDetailInfo
  
  private let iconImageView: UIImageView = .init()
  
  init(
      weatherImageCacheService: WeatherImageCacheServiceable,
      weatherDetailInfo info: WeatherDetailInfo
  ) {
    self.weatherImageCacheService = weatherImageCacheService
    self.info = info
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
  
  private func initialSetUp() {
    setUpView()
    setUpNavigationItem()
    setLayout()
    fetchWeatherIconImage()
  }
  
  private func setUpView() {
    view.backgroundColor = .white
  }
  
  private func setUpNavigationItem() {
    guard let listInfo = info.weatherForecastInfo else { return }
    
    let date: Date = .init(timeIntervalSince1970: listInfo.dateTime)
    navigationItem.title = date.formatted(using: .koreanLongForm)
  }
  
  private func setLayout() {
    guard let listInfo = info.weatherForecastInfo else { return }
    
    let weatherGroupLabel: WeatherInformationLabel = .init()
    let weatherDescriptionLabel: WeatherInformationLabel = .init()
    let temperatureLabel: WeatherInformationLabel = .init()
    let feelsLikeLabel: WeatherInformationLabel = .init()
    let maximumTemperatureLable: WeatherInformationLabel = .init()
    let minimumTemperatureLable: WeatherInformationLabel = .init()
    let popLabel: WeatherInformationLabel = .init()
    let humidityLabel: WeatherInformationLabel = .init()
    let sunriseTimeLabel: WeatherInformationLabel = .init()
    let sunsetTimeLabel: WeatherInformationLabel = .init()
    let spacingView: UIView = .init()
    spacingView.backgroundColor = .clear
    spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    
    let mainStackView: UIStackView = .init(
        arrangedSubviews: [
          iconImageView,
          weatherGroupLabel,
          weatherDescriptionLabel,
          temperatureLabel,
          feelsLikeLabel,
          maximumTemperatureLable,
          minimumTemperatureLable,
          popLabel,
          humidityLabel,
          sunriseTimeLabel,
          sunsetTimeLabel,
          spacingView
        ],
        alignment: .center,
        axis: .vertical,
        spacing: 8
    )
    
    weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
    weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
    
    view.addSubview(mainStackView)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
      iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.3)
    ])
    
    weatherGroupLabel.text = listInfo.weather.main
    weatherDescriptionLabel.text = listInfo.weather.description
    temperatureLabel.text = "현재 기온 : \(listInfo.main.temperature)\(info.temperatureUnit.symbol)"
    feelsLikeLabel.text = "체감 기온 : \(listInfo.main.windChillTemperature)\(info.temperatureUnit.symbol)"
    maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.highestTemperature)\(info.temperatureUnit.symbol)"
    minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.lowestTemperature)\(info.temperatureUnit.symbol)"
    popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
    humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
    
    if let cityInfo = info.cityInfo {
      let sunriseDate: Date = .init(timeIntervalSince1970: cityInfo.sunriseTime)
      let sunsetDate: Date = .init(timeIntervalSince1970: cityInfo.sunsetTime)
      
      sunriseTimeLabel.text = "일출 : \(sunriseDate.formatted(using: .koreanShortForm))"
      sunsetTimeLabel.text = "일몰 : \(sunsetDate.formatted(using: .koreanShortForm))"
    }
  }
  
  private func fetchWeatherIconImage() {
    guard let listInfo = info.weatherForecastInfo else { return }
    
    Task {
      let iconName: String = listInfo.weather.icon
      
      do {
        let image = try await weatherImageCacheService.execute(iconName: iconName)
        
        await MainActor.run {
          setIconImage(image)
        }
      } catch {
        print("WeatherDetailViewController - imageCacheService execute Error: \(error)")
      }
    }
  }
  
  private func setIconImage(_ image: UIImage) {
    iconImageView.image = image
  }
}
