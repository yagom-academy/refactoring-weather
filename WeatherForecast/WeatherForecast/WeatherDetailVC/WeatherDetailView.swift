//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import UIKit

final class WeatherDetailView: UIView {
    
    // MARK: - Properties
    private let iconImageView           : UIImageView = UIImageView()
    private let weatherGroupLabel       : CustomDetailLabel = CustomDetailLabel(with: .preferredFont(forTextStyle: .largeTitle))
    private let weatherDescriptionLabel : CustomDetailLabel = CustomDetailLabel(with: .preferredFont(forTextStyle: .largeTitle))
    private let temperatureLabel        : CustomDetailLabel = CustomDetailLabel()
    private let feelsLikeLabel          : CustomDetailLabel = CustomDetailLabel()
    private let maximumTemperatureLable : CustomDetailLabel = CustomDetailLabel()
    private let minimumTemperatureLable : CustomDetailLabel = CustomDetailLabel()
    private let popLabel                : CustomDetailLabel = CustomDetailLabel()
    private let humidityLabel           : CustomDetailLabel = CustomDetailLabel()
    private let sunriseTimeLabel        : CustomDetailLabel = CustomDetailLabel()
    private let sunsetTimeLabel         : CustomDetailLabel = CustomDetailLabel()
    private let spacingView             : UIView = UIView()

    private var imageManager            : ImageManagerProtocol
    var weatherForecastInfo             : WeatherForecastInfo?
    var cityInfo                        : City?
    var tempUnit                        : TemperatureUnit = .metric
    
    
    // MARK: - Init
    init(imageManager: ImageManagerProtocol, weatherForecastInfo: WeatherForecastInfo?, cityInfo: City?, tempUnit: TemperatureUnit) {
        self.imageManager = imageManager
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        
        super.init(frame: .zero)
        
        initialSetUp()
        setupMainStackView()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    
    private func initialSetUp() {
        backgroundColor = .white
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupMainStackView() {
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
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func updateUI() {
        
        guard let listInfo = weatherForecastInfo else { return }
        
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        if let cityInfo {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = .none
            formatter.timeStyle = .short
            formatter.locale = .init(identifier: "ko_KR")
            sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
        
        let iconName: String = listInfo.weather.icon
        imageManager.fetchImage(of: iconName) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
    }
}
