//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/31/24.
//

import UIKit

class WeatherDetailView: UIView {
    var iconImageView: UIImageView = {
        let imageView: UIImageView = .init()
        return imageView
    }()
    
    var weatherGroupLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    var weatherDescriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var feelsLikeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var maximumTemperatureLable: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var minimumTemperatureLable: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var popLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var humidityLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var sunriseTimeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var sunsetTimeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    var spacingView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
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
        
        let contentsStackView = setupContentsStackView()
        setupLayouts(contentsStackView)
    }
    
    private func setupIconImageView() {
        fetchIconImage()
    }
    
    private func setupWeatherGroupLabel() {
        weatherGroupLabel.text = weatherForecastInfo.weather.main
    }
    
    private func setupWeatherDescriptionLabel() {
        weatherDescriptionLabel.text = weatherForecastInfo.weather.description
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.text = "현재 기온 : \(weatherForecastInfo.main.temp)\(tempUnit.expression)"
    }
    
    private func setupFeelsLikeLabel() {
        feelsLikeLabel.text = "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(tempUnit.expression)"
    }
    
    private func setupMaximumTemperatureLabel() {
        maximumTemperatureLable.text = "최고 기온 : \(weatherForecastInfo.main.tempMax)\(tempUnit.expression)"
    }
    
    private func setupMinimumTemperatureLabel() {
        minimumTemperatureLable.text = "최저 기온 : \(weatherForecastInfo.main.tempMin)\(tempUnit.expression)"
    }
    
    private func setupPopLabel() {
        popLabel.text = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
    }
    
    private func setupHumidityLabel() {
        humidityLabel.text = "습도 : \(weatherForecastInfo.main.humidity)%"
    }
    
    private func setupSunriseTimeLabel() {
        let sunRiseDate: Date = .init(timeIntervalSince1970: cityInfo.sunrise)
        sunriseTimeLabel.text = "일출 : \(sunRiseDate.toString(type: .none, timeStyle: .short))"
    }
    
    private func setupSunsetTimeLabel() {
        let sunSetDate: Date = .init(timeIntervalSince1970: cityInfo.sunset)
        sunsetTimeLabel.text = "일몰 : \(sunSetDate.toString(type: .none, timeStyle: .short))"
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
