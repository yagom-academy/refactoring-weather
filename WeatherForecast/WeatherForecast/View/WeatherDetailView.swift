//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/31/24.
//

import UIKit

final class WeatherDetailView: UIView {
    var contentStackView: WeatherDetailContentStackView = {
        let stackView: WeatherDetailContentStackView = .init()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let weatherForecastInfo: WeatherForecastInfo
    let cityInfo: City
    let tempUnit: TempUnit
    let imageService: ImageFetchable
    
    init(
        weatherForecastInfo: WeatherForecastInfo,
        cityInfo: City,
        tempUnit: TempUnit = .metric,
        imageService: ImageFetchable
    ) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        self.imageService = imageService
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupIconImageView()
        setupWeatherGroupLabel()
        setupWeatherDescriptionLabel()
        setupTemperatureLabel()
        setupFeelsLikeLabel()
        setupMaximumTemperatureLabel()
        setupMinimumTemperatureLabel()
        setupPopLabel()
        setupHumidityLabel()
        setupSunriseTimeLabel()
        setupSunsetTimeLabel()
        
        setupContentsStackView()
        setupLayouts()
    }
    
    private func setupIconImageView() {
        fetchIconImage()
    }
    
    private func setupWeatherGroupLabel() {
        contentStackView.setupWeatherGroupLabel(with: weatherForecastInfo.weather.main)
    }
    
    private func setupWeatherDescriptionLabel() {
        contentStackView.setupWeatherDescriptionLabel(with: weatherForecastInfo.weather.description)
    }
    
    private func setupTemperatureLabel() {
        contentStackView.setupTemperatureLabel(
            with: weatherForecastInfo.main.temp,
            expression: tempUnit.expression
        )
    }
    
    private func setupFeelsLikeLabel() {
        contentStackView.setupFeelsLikeLabel(
            with: weatherForecastInfo.main.feelsLike,
            expression: tempUnit.expression
        )
    }
    
    private func setupMaximumTemperatureLabel() {
        contentStackView.setupMaximumTemperatureLabel(
            with: weatherForecastInfo.main.tempMax,
            expression: tempUnit.expression
        )
    }
    
    private func setupMinimumTemperatureLabel() {
        contentStackView.setupMinimumTemperatureLabel(
            with: weatherForecastInfo.main.tempMin,
            expression: tempUnit.expression
        )
    }
    
    private func setupPopLabel() {
        contentStackView.setupPopLabel(with: weatherForecastInfo.main.pop)
    }
    
    private func setupHumidityLabel() {
        contentStackView.setupHumidityLabel(with: weatherForecastInfo.main.humidity)
    }
    
    private func setupSunriseTimeLabel() {
        let sunRiseDate: Date = .init(timeIntervalSince1970: cityInfo.sunrise)
        contentStackView.setupSunriseTimeLabel(with: sunRiseDate)
    }
    
    private func setupSunsetTimeLabel() {
        let sunSetDate: Date = .init(timeIntervalSince1970: cityInfo.sunset)
        contentStackView.setupSunsetTimeLabel(with: sunSetDate)
    }
    
    
    private func setupContentsStackView() {
        contentStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        
        addSubview(contentStackView)
    }
    
    private func setupLayouts() {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                   constant: -16)
        ])
        
    }
    
    private func fetchIconImage() {
        let iconName: String = weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        Task {
            if let image: UIImage = await imageService.fetchIconImage(urlString: urlString) {
                contentStackView.setupIconImage(with: image)
            }
        }
    }
}
