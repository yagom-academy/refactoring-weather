//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/4/24.
//

import UIKit

final class WeatherDetailView: UIView {
    
    private let iconImageView: UIImageView = .init()
    private let weatherGroupLabel: UILabel = .init()
    private let weatherDescriptionLabel: UILabel = .init()
    private let temperatureLabel: UILabel = .init()
    private let feelsLikeLabel: UILabel = .init()
    private let maximumTemperatureLable: UILabel = .init()
    private let minimumTemperatureLable: UILabel = .init()
    private let popLabel: UILabel = .init()
    private let humidityLabel: UILabel = .init()
    private let sunriseTimeLabel: UILabel = .init()
    private let sunsetTimeLabel: UILabel = .init()
    private let spacingView: UIView = .init()
    private var networkManager: NetworkManagerDelegate
    private let dateformatter: DateFormattable
    
    init(networkManager: NetworkManagerDelegate,
         dateformatter: DateFormattable = CustomDateFormatter(timeStyle: .short)
    ) {
        self.networkManager = networkManager
        self.dateformatter = dateformatter
        super.init(frame: .zero)
        initialSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSettings() {
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
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
        
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
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
    
    func configure(with weatherDetailInfo: WeatherDetailInfo?) {
        guard let listInfo: WeatherForecastInfo = weatherDetailInfo?.weatherForecastInfo,
              let tempUnit: TempUnit = weatherDetailInfo?.tempUnit
        else { return }
        
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        if let cityInfo: City = weatherDetailInfo?.cityInfo {
            let sunriseDate: Date = .init(timeIntervalSince1970: cityInfo.sunrise)
            let sunsetDate: Date = .init(timeIntervalSince1970: cityInfo.sunset)
            
            sunriseTimeLabel.text = "일출 : \(dateformatter.string(from: sunriseDate)))"
            sunsetTimeLabel.text = "일몰 : \(dateformatter.string(from: sunsetDate)))"
        }
        
        let iconName: String = listInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        iconImageView.setImage(from: urlString)
    }
}
