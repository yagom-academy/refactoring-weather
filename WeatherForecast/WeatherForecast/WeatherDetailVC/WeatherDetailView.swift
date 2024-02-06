//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import UIKit

final class WeatherDetailView: UIView {
    
    // MARK: - Properties
    private var mainStackView           : UIStackView!
    private let iconImageView           : UIImageView = UIImageView()
    private let weatherGroupLabel       : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel(with: .preferredFont(forTextStyle: .largeTitle))
    private let weatherDescriptionLabel  : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel(with: .preferredFont(forTextStyle: .largeTitle))
    private let temperatureLabel        : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let feelsLikeLabel          : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let maximumTemperatureLable  : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let minimumTemperatureLable  : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let popLabel                : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let humidityLabel            : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let sunriseTimeLabel         : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let sunsetTimeLabel          : DetailViewWeatherInfoLabel = DetailViewWeatherInfoLabel()
    private let spacingView             : UIView = UIView()

    private var imageManager            : ImageManagerProtocol
    var weatherForecastInfo             : WeatherForecast?
    var cityInfo                        : CityInfo?
    
    
    // MARK: - Init
    init(imageManager: ImageManagerProtocol, weatherForecastInfo: WeatherForecast?, cityInfo: CityInfo?) {
        self.imageManager = imageManager
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        
        super.init(frame: .zero)
        
        initialSetUp()
        setupMainStackView()
        layoutMainStackView()
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
        mainStackView = .init(arrangedSubviews: [
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
    }
    
    func layoutMainStackView() {
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
        
        guard let weatherItem = weatherForecastInfo, let cityInfo = cityInfo else { return }
        
        weatherGroupLabel.text = weatherItem.weatherMainDescription
        weatherDescriptionLabel.text = weatherItem.weatherDetailDescription
        temperatureLabel.text = weatherItem.currentTemperature
        feelsLikeLabel.text = weatherItem.feelsLikeTemperature
        maximumTemperatureLable.text = weatherItem.maxTemperature
        minimumTemperatureLable.text = weatherItem.minTemperature
        popLabel.text = weatherItem.precipitation
        humidityLabel.text = weatherItem.humidity
        
        sunriseTimeLabel.text = cityInfo.sunriseTime
        sunsetTimeLabel.text = cityInfo.sunsetTime
        
        let iconName: String = weatherItem.weatherIcon
        updateImage(with: iconName)
    }
    
    private func updateImage(with iconName: String) {
        imageManager.fetchImage(of: iconName) { [weak self] image in
            self?.iconImageView.image = image
        }
    }
}
