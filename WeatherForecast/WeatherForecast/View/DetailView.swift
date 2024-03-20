//
//  DetailView.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/18/24.
//

import UIKit

struct DetailInfo {
    var weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
    }
}

final class DetailView: UIView {
    private let info: DetailInfo
    private let iconImageView: UIImageView = UIImageView()
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City) {
        self.info = DetailInfo(weatherForecastInfo: weatherForecastInfo, cityInfo: cityInfo)
        super.init(frame: .zero)
        setupLayout()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {let weatherGroupLabel: UILabel = UILabel()
        let weatherDescriptionLabel = DetailViewCustomLabel()
        let temperatureLabel = DetailViewCustomLabel()
        let feelsLikeLabel = DetailViewCustomLabel()
        let maximumTemperatureLable = DetailViewCustomLabel()
        let minimumTemperatureLable = DetailViewCustomLabel()
        let popLabel = DetailViewCustomLabel()
        let humidityLabel = DetailViewCustomLabel()
        let sunriseTimeLabel = DetailViewCustomLabel()
        let sunsetTimeLabel = DetailViewCustomLabel()
        let spacingView: UIView = UIView()
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        func mainStackView() -> UIStackView {
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
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            
            return mainStackView
        }
        
        func layoutLabels() {
            weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
            weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
            weatherGroupLabel.text = info.weatherForecastInfo.weather.main
            weatherDescriptionLabel.text = info.weatherForecastInfo.weather.description
            temperatureLabel.text = "현재 기온 : \(Shared.tempUnit.applyTempUnit(temp: info.weatherForecastInfo.main.temp))\(Shared.tempUnit.expression)"
            feelsLikeLabel.text = "체감 기온 : \(Shared.tempUnit.applyTempUnit(temp: info.weatherForecastInfo.main.feelsLike))\(Shared.tempUnit.expression)"
            maximumTemperatureLable.text = "최고 기온 : \(Shared.tempUnit.applyTempUnit(temp: info.weatherForecastInfo.main.tempMax))\(Shared.tempUnit.expression)"
            minimumTemperatureLable.text = "최저 기온 : \(Shared.tempUnit.applyTempUnit(temp: info.weatherForecastInfo.main.tempMin))\(Shared.tempUnit.expression)"
            popLabel.text = "강수 확률 : \(info.weatherForecastInfo.main.pop * 100)%"
            humidityLabel.text = "습도 : \(info.weatherForecastInfo.main.humidity)%"
            sunriseTimeLabel.text = "일출 : \(DateFormatter.KRShortStyle.string(from: Date(timeIntervalSince1970: info.cityInfo.sunrise)))"
            
            sunsetTimeLabel.text = "일몰 : \(DateFormatter.KRShortStyle.string(from: Date(timeIntervalSince1970: info.cityInfo.sunset)))"
        }
        
        func layoutMainStackView() {
            let mainStackView = mainStackView()
            addSubview(mainStackView)
            
            let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                       constant: 16),
                mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                       constant: -16)
            ])
        }
        
        func layoutIconImage() {
            let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
                iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                     multiplier: 0.3)
            ])
        }

        layoutLabels()
        layoutMainStackView()
        layoutIconImage()
    }
    
    private func loadImage() {
        let iconName: String = info.weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        ImageChacher.shared.load(urlString: urlString) { image in
            self.iconImageView.image = image
        }
    }
}
