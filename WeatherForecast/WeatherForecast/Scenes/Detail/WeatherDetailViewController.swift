//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {

    private var weatherForecastInfo: WeatherForecast
    private var cityInfo: City
    private var tempUnit: TempUnit
    
    private let iconImageView: UIImageView = UIImageView()
    private let temperatureLabel: UILabel = UILabel()
    private let feelsLikeLabel: UILabel = UILabel()
    private let maximumTemperatureLable: UILabel = UILabel()
    private let minimumTemperatureLable: UILabel = UILabel()
    private let popLabel: UILabel = UILabel()
    private let humidityLabel: UILabel = UILabel()
    private let sunriseTimeLabel: UILabel = UILabel()
    private let sunsetTimeLabel: UILabel = UILabel()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let weatherGroupLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let spacingView: UIView = {
        let spacingView = UIView()
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return spacingView
    }()
    
    init(weatherForecastInfo: WeatherForecast,
         cityInfo: City,
         tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        setConstraints()
        setWeatherForecastData()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        
        let views = [
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
        ]
        
        views.forEach { subview in
            guard let label: UILabel = subview as? UILabel else { return }
            label.textColor = .black
            label.backgroundColor = .clear
            label.numberOfLines = 1
            label.textAlignment = .center
            label.font = .preferredFont(forTextStyle: .body)
        }
        
        views.forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // mainStackView
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                   constant: -16),
            // iconImageView
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                 multiplier: 0.3)
        ])
    }
    
    private func setWeatherForecastData() {
        navigationItem.title = weatherForecastInfo.updatedDate.value
        
        let title = weatherForecastInfo.title
        weatherGroupLabel.text = title?.value ?? ""
        
        let description = weatherForecastInfo.description
        weatherDescriptionLabel.text = description?.value ?? ""
        
        temperatureLabel.text = "현재 기온 : \(weatherForecastInfo.temp)"
        feelsLikeLabel.text = "체감 기온 : \(weatherForecastInfo.feelsLike)"
        maximumTemperatureLable.text = "최고 기온 : \(weatherForecastInfo.tempMax)"
        minimumTemperatureLable.text = "최저 기온 : \(weatherForecastInfo.tempMin)"
        popLabel.text = "강수 확률 : \(weatherForecastInfo.pop)"
        humidityLabel.text = "습도 : \(weatherForecastInfo.humidity)"
        
        sunriseTimeLabel.text = "일출 : \(cityInfo.sunrise)"
        sunsetTimeLabel.text = "일몰 : \(cityInfo.sunset)"
        
        iconImageView.loadImage(with: weatherForecastInfo.iconUrl.value)
    }
}
