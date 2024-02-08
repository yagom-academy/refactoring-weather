//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    
    private let iconImageView: UIImageView = .init()
    private let weatherGroupLabel: UILabel = .init()
    private let weatherDescriptionLabel: UILabel = .init()
    private let temperatureLabel: UILabel = .init()
    private let feelsLikeLabel: UILabel = .init()
    private let maximumTemperatureLable: UILabel = .init()
    private let minimumTemperatureLable: UILabel = .init()
    private let popLabel: UILabel = .init()
    private let humidityLabel: UILabel = .init()
    private let sunriseTimeLabel: UILabel = .init()
    private let sunsetTimeLabel: UILabel = .init()
    private let spacingView: UIView = .init()
    private let weatherInfo: WeatherForecastInfo
    private let cityInfo: CityDetailInfo
    private let mainInfo: MainInfo
    private let tempUnit: TempUnit
  
    init(weatherInfo: WeatherForecastInfo, mainInfo: MainInfo, cityInfo: CityDetailInfo, tempUnit: TempUnit) {
        self.weatherInfo = weatherInfo
        self.mainInfo = mainInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        updateWeatherInfo(listInfo: weatherInfo, mainInfo: mainInfo, tempUnit: tempUnit)
        updateCityInfo(cityInfo)
        Task {
            await updateWeatherIcon(iconName: weatherInfo.weather.icon)
        }
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white
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
    }
   
}

extension WeatherDetailViewController {
    
    func updateWeatherInfo(listInfo: WeatherForecastInfo, mainInfo: MainInfo,tempUnit: TempUnit){
        
        navigationItem.title = listInfo.dtTxt
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        temperatureLabel.text = "현재 기온 : \(mainInfo.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(mainInfo.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(mainInfo.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(mainInfo.tempMin)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(mainInfo.pop * 100)%"
        humidityLabel.text = "습도 : \(mainInfo.humidity)%"
    }
    @MainActor
    func updateWeatherIcon(iconName: String) async {
        if let iconImage = await TransforJSON.shared.fetchWeatherIconImage(iconName: iconName) {
            self.iconImageView.image = iconImage
        }
    }
    func updateCityInfo(_ cityInfo: CityDetailInfo) {
        sunriseTimeLabel.text = "일출 : \(cityInfo.sunrise)"
        sunsetTimeLabel.text = "일몰 : \(cityInfo.sunset)"
    }
   
}
