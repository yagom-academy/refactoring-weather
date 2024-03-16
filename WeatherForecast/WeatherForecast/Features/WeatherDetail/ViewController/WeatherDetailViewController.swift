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

final class WeatherDetailViewController: UIViewController, DateFormattable {
  private let weatherImageCacheService: WeatherImageCacheServiceable
  private var info: WeatherDetailInfo
  
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
    setLayout()
  }
  
  private func setUpView() {
    view.backgroundColor = .white
  }
  
  private func setLayout() {
    guard let listInfo = info.weatherForecastInfo else { return }
    navigationItem.title = dateFormat(from: listInfo.dateTime, with: .KoreanLongForm)
    
    let iconImageView: UIImageView = .init()
    let weatherGroupLabel: UILabel = .init()
    let weatherDescriptionLabel: UILabel = .init()
    let temperatureLabel: UILabel = .init()
    let feelsLikeLabel: UILabel = .init()
    let maximumTemperatureLable: UILabel = .init()
    let minimumTemperatureLable: UILabel = .init()
    let popLabel: UILabel = .init()
    let humidityLabel: UILabel = .init()
    let sunriseTimeLabel: UILabel = .init()
    let sunsetTimeLabel: UILabel = .init()
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
    
    mainStackView.arrangedSubviews.forEach { subview in
      guard let subview: UILabel = subview as? UILabel else { return }
      subview.textColor = .black
      subview.backgroundColor = .clear
      subview.numberOfLines = 1
      subview.textAlignment = .center
      subview.font = .preferredFont(forTextStyle: .body)
    }
    
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
      sunriseTimeLabel.text = "일출 : \(dateFormat(from: cityInfo.sunriseTime, with: .KoreanShortForm))"
      sunsetTimeLabel.text = "일몰 : \(dateFormat(from: cityInfo.sunsetTime, with: .KoreanShortForm))"
    }
    
    Task {
      let iconName: String = listInfo.weather.icon
      
      do {
        let image = try await weatherImageCacheService.execute(iconName: iconName)
        
        await MainActor.run {
          iconImageView.image = image
        }
      } catch {
        print("WeatherDetailViewController - imageCacheService execute Error: \(error)")
      }
    }
  }
}
