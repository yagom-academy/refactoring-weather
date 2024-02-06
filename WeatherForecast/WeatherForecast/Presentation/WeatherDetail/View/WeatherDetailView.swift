//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/05.
//

import UIKit

class WeatherDetailView: UIView {
    // MARK: - Properties
    private var weatherDetailInfo: WeatherDetailInfo?
    private let imageService: NetworkService
    
    // MARK: - UI
    private let iconImageView: UIImageView = UIImageView()
    private let weatherGroupLabel: UILabel = UILabel()
    private let weatherDescriptionLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let feelsLikeLabel: UILabel = UILabel()
    private let maximumTemperatureLabel: UILabel = UILabel()
    private let minimumTemperatureLabel: UILabel = UILabel()
    private let popLabel: UILabel = UILabel()
    private let humidityLabel: UILabel = UILabel()
    private let sunriseTimeLabel: UILabel = UILabel()
    private let sunsetTimeLabel: UILabel = UILabel()
    private let spacingView: UIView = UIView()
    
    // MARK: - Init
    init(weatherDetailInfo: WeatherDetailInfo?,
         imageService: NetworkService) {
        self.weatherDetailInfo = weatherDetailInfo
        self.imageService = imageService
        super.init(frame: .zero)
        layoutView()
        updateLabel()
        updateIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layoutView() {
        self.backgroundColor = .white
        
        makeLabel()
        
        let mainStackView: UIStackView = .init(arrangedSubviews: [
            iconImageView,
            weatherGroupLabel,
            weatherDescriptionLabel,
            temperatureLabel,
            feelsLikeLabel,
            maximumTemperatureLabel,
            minimumTemperatureLabel,
            popLabel,
            humidityLabel,
            sunriseTimeLabel,
            sunsetTimeLabel,
            spacingView
        ])
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
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
    
    private func makeLabel() {
        let largeTitleLabels: [UILabel] = [weatherGroupLabel, weatherDescriptionLabel]
        
        largeTitleLabels.forEach { label in
            label.makeLabel(font: .preferredFont(forTextStyle: .largeTitle))
        }

        let bodyLabels: [UILabel] = [temperatureLabel, feelsLikeLabel, maximumTemperatureLabel, minimumTemperatureLabel, popLabel, humidityLabel, sunriseTimeLabel, sunsetTimeLabel]
        
        bodyLabels.forEach { label in
            label.makeLabel()
        }
    }
    
    private func updateLabel() {
        weatherGroupLabel.text = weatherForcastInfo?.weather.main
        weatherDescriptionLabel.text = weatherForcastInfo?.weather.description
        temperatureLabel.text = "현재 기온 : \(String(describing: main.temp))\(String(describing: tempUnit.expression))"
        feelsLikeLabel.text = "체감 기온 : \(String(describing: main.feelsLike))\(String(describing: tempUnit.expression))"
        maximumTemperatureLabel.text = "최고 기온 : \(String(describing: main.tempMax))\(String(describing: tempUnit.expression))"
        minimumTemperatureLabel.text = "최저 기온 : \(String(describing: main.tempMin))\(String(describing: tempUnit.expression))"
        popLabel.text = "강수 확률 : \(String(describing: main.pop))"
        humidityLabel.text = "습도 : \(String(describing: main.humidity))"
        sunriseTimeLabel.text = "일출 : \(String(describing: cityInfo.sunrise))"
        sunsetTimeLabel.text = "일몰 : \(String(describing: cityInfo.sunset))"
    }
    
    private func updateIcon() {
        Task {
            iconImageView.image = try? await imageService.fetchImage(iconName: weatherForcastInfo?.weather.icon ?? "", urlSession: URLSession.shared)
        }

    }
}
