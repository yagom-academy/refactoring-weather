//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
  
  var weatherForecastInfo: WeatherForecastInfo?
  var cityInfo: City?
  var tempUnit: TempUnit = .metric
  
  let dateFormatter: DateFormatter = {
    let formatter: DateFormatter = .init()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
  
  private func initialSetUp() {
    view.backgroundColor = .white
    
    guard let listInfo = weatherForecastInfo else { return }
    
    let date: Date = .init(timeIntervalSince1970: listInfo.dt)
    navigationItem.title = dateFormatter.string(from: date)
    
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
    temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempUnit.expression)"
    feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempUnit.expression)"
    maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempUnit.expression)"
    minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempUnit.expression)"
    popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
    humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
    
    if let cityInfo {
      let formatter: DateFormatter = .init()
      formatter.dateFormat = .none
      formatter.timeStyle = .short
      formatter.locale = .init(identifier: "ko_KR")
      sunriseTimeLabel.text = "일출 : \(formatter.string(from: .init(timeIntervalSince1970: cityInfo.sunrise)))"
      sunsetTimeLabel.text = "일몰 : \(formatter.string(from: .init(timeIntervalSince1970: cityInfo.sunset)))"
    }
    
    Task {
      let iconName: String = listInfo.weather.icon
      let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
      
      guard let url: URL = .init(string: urlString),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let image: UIImage = .init(data: data) else {
        return
      }
      
      iconImageView.image = image
    }
  }
}
