//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
  
  private let iconImageView: UIImageView = UIImageView()
  private let weatherGroupLabel: UILabel = UILabel()
  private let weatherDescriptionLabel: UILabel = UILabel()
  private let temperatureLabel: UILabel = UILabel()
  private let feelsLikeLabel: UILabel = UILabel()
  private let maximumTemperatureLable: UILabel = UILabel()
  private let minimumTemperatureLable: UILabel = UILabel()
  private let popLabel: UILabel = UILabel()
  private let humidityLabel: UILabel = UILabel()
  private let sunriseTimeLabel: UILabel = UILabel()
  private let sunsetTimeLabel: UILabel = UILabel()
  private let spacingView: UIView = UIView()
  
  struct Dependency {
    let defaultDateFormatter: DateFormatterContextService
    let sunsetDateFormatter: DateFormatterContextService
    let weatherForecastInfo: WeatherForecastInfo?
    let cityInfo: City?
    let tempUnitManager: TempUnitManagerService
  }
  
  private let dependency: Dependency
  init(dependency: Dependency) {
    self.dependency = dependency
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
  
  private func initialSetUp() {
    view.backgroundColor = .white
    
    guard let listInfo = dependency.weatherForecastInfo else { return }
    
    navigationItem.title = dependency.defaultDateFormatter.string(from: listInfo.dt)
    
    
    spacingView.backgroundColor = .clear
    spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    
    let mainStackView: UIStackView = .init(arrangedSubviews: [
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
    ])
    
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
    
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = 8
    view.addSubview(mainStackView)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                             constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                              constant: -16),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
      iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                           multiplier: 0.3)
    ])
    
    weatherGroupLabel.text = listInfo.weather.main
    weatherDescriptionLabel.text = listInfo.weather.description
    temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(dependency.tempUnitManager.currentValue.expression)"
    feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(dependency.tempUnitManager.currentValue.expression)"
    maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(dependency.tempUnitManager.currentValue.expression)"
    minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(dependency.tempUnitManager.currentValue.expression)"
    popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
    humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
    
    if let cityInfo = dependency.cityInfo {
      let dateFormatter = dependency.sunsetDateFormatter
      sunriseTimeLabel.text = "일출 : \(dateFormatter.string(from: cityInfo.sunrise))"
      sunsetTimeLabel.text = "일몰 : \(dateFormatter.string(from: cityInfo.sunset))"
    }
    
    Task {
      let iconName: String = listInfo.weather.icon
      let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
      let image = await ImageProvider.shared.image(url: urlString)
      iconImageView.image = image
    }
  }
}
