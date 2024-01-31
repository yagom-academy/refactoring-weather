//
//  WeatherDetailContentStackView.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/1/24.
//

import UIKit

final class WeatherDetailContentStackView: UIStackView {
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init()
        return imageView
    }()
    
    private let weatherGroupLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let maximumTemperatureLable: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let minimumTemperatureLable: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let popLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let sunriseTimeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let sunsetTimeLabel: UILabel = {
        let label: UILabel = .init()
        return label
    }()
    
    private let spacingView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupSubviews()
        setupLayouts()
    }
    
    private func setupSubviews() {
        addArrangedSubview(iconImageView)
        addArrangedSubview(weatherGroupLabel)
        addArrangedSubview(weatherDescriptionLabel)
        addArrangedSubview(temperatureLabel)
        addArrangedSubview(feelsLikeLabel)
        addArrangedSubview(maximumTemperatureLable)
        addArrangedSubview(minimumTemperatureLable)
        addArrangedSubview(popLabel)
        addArrangedSubview(humidityLabel)
        addArrangedSubview(sunriseTimeLabel)
        addArrangedSubview(sunsetTimeLabel)
        addArrangedSubview(spacingView)
    }
    
    private func setupLayouts() {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.3)
        ])
    }
    
    func setupIconImage(with image: UIImage) {
        iconImageView.image = image
    }
    
    func setupWeatherGroupLabel(with main: String) {
        weatherGroupLabel.text = main
    }
    
    func setupWeatherDescriptionLabel(with description: String) {
        weatherDescriptionLabel.text = description
    }
    
    func setupTemperatureLabel(with temp: Double, expression: String) {
        temperatureLabel.text = "현재 기온 : \(temp)\(expression)"
    }
    
    func setupFeelsLikeLabel(with temp: Double, expression: String) {
        feelsLikeLabel.text = "체감 기온 : \(temp)\(expression)"
    }
    
    func setupMaximumTemperatureLabel(with temp: Double, expression: String) {
        maximumTemperatureLable.text = "최고 기온 : \(temp)\(expression)"
    }
    
    func setupMinimumTemperatureLabel(with temp: Double, expression: String) {
        minimumTemperatureLable.text = "최저 기온 : \(temp)\(expression)"
    }
    
    func setupPopLabel(with pop: Double) {
        popLabel.text = "강수 확률 : \(pop * 100)%"
    }
    
    func setupHumidityLabel(with humidity: Double) {
        humidityLabel.text = "습도 : \(humidity)%"
    }
    
    func setupSunriseTimeLabel(with date: Date) {
        sunriseTimeLabel.text = "일출 : \(date.toString(type: .none, timeStyle: .short))"
    }
    
    func setupSunsetTimeLabel(with date: Date) {
        sunsetTimeLabel.text = "일몰 : \(date.toString(type: .none, timeStyle: .short))"
    }
}
