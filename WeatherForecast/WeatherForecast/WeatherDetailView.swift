//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/31/24.
//

import UIKit

class WeatherDetailView: UIView {
    var iconImageView: UIImageView!
    var weatherGroupLabel: UILabel!
    var weatherDescriptionLabel: UILabel!
    var temperatureLabel: UILabel!
    var feelsLikeLabel: UILabel!
    var maximumTemperatureLable: UILabel!
    var minimumTemperatureLable: UILabel!
    var popLabel: UILabel!
    var humidityLabel: UILabel!
    var sunriseTimeLabel: UILabel!
    var sunsetTimeLabel: UILabel!
    var spacingView: UIView!
    
    let weatherForecastInfo: WeatherForecastInfo
    let cityInfo: City
    let tempUnit: TempUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit = .metric) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
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
        setupSpacingView()
        let contentsStackView = setupContentsStackView()
        setupLayouts(contentsStackView)
    }
    
    private func setupIconImageView() {
        iconImageView = .init()
        fetchIconImage()
    }
    
    private func setupWeatherGroupLabel() {
        weatherGroupLabel = .init()
        weatherGroupLabel.text = weatherForecastInfo.weather.main
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private func setupWeatherDescriptionLabel() {
        weatherDescriptionLabel = .init()
        weatherDescriptionLabel.text = weatherForecastInfo.weather.description
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel = .init()
        temperatureLabel.text = "현재 기온 : \(weatherForecastInfo.main.temp)\(tempUnit.expression)"
    }
    
    private func setupFeelsLikeLabel() {
        feelsLikeLabel = .init()
        feelsLikeLabel.text = "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(tempUnit.expression)"
    }
    
    private func setupMaximumTemperatureLabel() {
        maximumTemperatureLable = .init()
        maximumTemperatureLable.text = "최고 기온 : \(weatherForecastInfo.main.tempMax)\(tempUnit.expression)"
    }
    
    private func setupMinimumTemperatureLabel() {
        minimumTemperatureLable = .init()
        minimumTemperatureLable.text = "최저 기온 : \(weatherForecastInfo.main.tempMin)\(tempUnit.expression)"
    }
    
    private func setupPopLabel() {
        popLabel = .init()
        popLabel.text = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
    }
    
    private func setupHumidityLabel() {
        humidityLabel = .init()
        humidityLabel.text = "습도 : \(weatherForecastInfo.main.humidity)%"
    }
    
    private func setupSunriseTimeLabel() {
        sunriseTimeLabel = .init()
        let sunRiseDate: Date = .init(timeIntervalSince1970: cityInfo.sunrise)
        sunriseTimeLabel.text = "일출 : \(sunRiseDate.toString(type: .none, timeStyle: .short))"
    }
    
    private func setupSunsetTimeLabel() {
        sunsetTimeLabel = .init()
        let sunSetDate: Date = .init(timeIntervalSince1970: cityInfo.sunset)
        sunsetTimeLabel.text = "일몰 : \(sunSetDate.toString(type: .none, timeStyle: .short))"
    }
    
    private func setupSpacingView() {
        spacingView = .init()
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupContentsStackView() -> UIStackView {
        let contentsStackView: UIStackView = .init(arrangedSubviews: [
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
        
        contentsStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        
        contentsStackView.axis = .vertical
        contentsStackView.alignment = .center
        contentsStackView.spacing = 8
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentsStackView)
        return contentsStackView
    }
    
    private func setupLayouts(_ contentsStackView: UIStackView) {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            contentsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: 16),
            contentsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                   constant: -16),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                 multiplier: 0.3)
        ])
        
    }
    
    private func fetchIconImage() {
        Task {
            let iconName: String = weatherForecastInfo.weather.icon
            let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
            
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            iconImageView.image = image
        }
    }
}
