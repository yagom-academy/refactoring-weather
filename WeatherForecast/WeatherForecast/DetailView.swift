//
//  DetailView.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/18/24.
//

import UIKit

protocol DetailViewInfoProtocol {
    var weatherForecastInfo: WeatherForecastInfo { get set }
    var cityInfo: City { get set }
    var tempUnit: TempUnit { get set }
}

class DetailInfo: DetailViewInfoProtocol {
    var weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City
    var tempUnit: TempUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
    }
}

class DetailView: UIView {
    private let infoProtocol: DetailViewInfoProtocol
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit) {
        self.infoProtocol = DetailInfo(weatherForecastInfo: weatherForecastInfo, cityInfo: cityInfo, tempUnit: tempUnit)
        super.init(frame: .zero)
        layViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layViews() {
        let iconImageView: UIImageView = UIImageView()
        let weatherGroupLabel: UILabel = UILabel()
        let weatherDescriptionLabel: UILabel = UILabel()
        let temperatureLabel: UILabel = UILabel()
        let feelsLikeLabel: UILabel = UILabel()
        let maximumTemperatureLable: UILabel = UILabel()
        let minimumTemperatureLable: UILabel = UILabel()
        let popLabel: UILabel = UILabel()
        let humidityLabel: UILabel = UILabel()
        let sunriseTimeLabel: UILabel = UILabel()
        let sunsetTimeLabel: UILabel = UILabel()
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
                    
            mainStackView.arrangedSubviews.forEach { subview in
                guard let subview: UILabel = subview as? UILabel else { return }
                subview.textColor = .black
                subview.backgroundColor = .clear
                subview.numberOfLines = 1
                subview.textAlignment = .center
                subview.font = .preferredFont(forTextStyle: .body)
            }
            
            mainStackView.axis = .vertical
            mainStackView.alignment = .center
            mainStackView.spacing = 8
            
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            
            return mainStackView
        }
        
        func layLabels() {
            weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
            weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
            weatherGroupLabel.text = infoProtocol.weatherForecastInfo.weather.main
            weatherDescriptionLabel.text = infoProtocol.weatherForecastInfo.weather.description
            temperatureLabel.text = "현재 기온 : \(infoProtocol.weatherForecastInfo.main.temp)\(infoProtocol.tempUnit.expression)"
            feelsLikeLabel.text = "체감 기온 : \(infoProtocol.weatherForecastInfo.main.feelsLike)\(infoProtocol.tempUnit.expression)"
            maximumTemperatureLable.text = "최고 기온 : \(infoProtocol.weatherForecastInfo.main.tempMax)\(infoProtocol.tempUnit.expression)"
            minimumTemperatureLable.text = "최저 기온 : \(infoProtocol.weatherForecastInfo.main.tempMin)\(infoProtocol.tempUnit.expression)"
            popLabel.text = "강수 확률 : \(infoProtocol.weatherForecastInfo.main.pop * 100)%"
            humidityLabel.text = "습도 : \(infoProtocol.weatherForecastInfo.main.humidity)%"
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = .none
            formatter.timeStyle = .short
            formatter.locale = .init(identifier: "ko_KR")
            sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: infoProtocol.cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: infoProtocol.cityInfo.sunset)))"
        }
        
        func layMainStackView() {
            let mainStackView = mainStackView()
            addSubview(mainStackView)
            
            
            let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
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
        

        
        layLabels()
        layMainStackView()
        loadImage(to: iconImageView)
    }
    
    func loadImage(to imageView: UIImageView) {
        let iconName: String = infoProtocol.weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        ImageChacher.shared.load(urlString: urlString) { image in
            imageView.image = image
        }
    }
}
