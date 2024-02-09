//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by 강동영 on 1/31/24.
//

import UIKit

final class WeatherDetailView: UIView {
    private let iconImageView: UIImageView = UIImageView()
    private let weatherGroupLabel: UILabel = UILabel()
    private let weatherDescriptionLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let feelsLikeLabel: UILabel = UILabel()
    private let maximumTemperatureLable: UILabel = UILabel()
    private let minimumTemperatureLable: UILabel = UILabel()
    private let popLabel: UILabel = UILabel()
    private let humidityLabel: UILabel = UILabel()
    private let sunriseTimeLabel: UILabel = UILabel()
    private let sunsetTimeLabel: UILabel = UILabel()
    private let spacingView: UIView = UIView()
    
    private let dataFetcher: DataFetchable
    private let mainStackView: UIStackView = UIStackView()
    
    init(weatherForecastInfo: WeatherForecastInfo, dataFetcher: DataFetchable) {
        self.weatherForecastInfo = weatherForecastInfo
        self.dataFetcher = dataFetcher
        super.init(frame: .zero)
        
        backgroundColor = .white
        Task {
            await initialUIData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City?
    var tempUnit: TempUnit = .celsius
}

extension WeatherDetailView {
    private func layoutStackView() {
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(weatherGroupLabel)
        mainStackView.addArrangedSubview(weatherDescriptionLabel)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(feelsLikeLabel)
        mainStackView.addArrangedSubview(maximumTemperatureLable)
        mainStackView.addArrangedSubview(minimumTemperatureLable)
        mainStackView.addArrangedSubview(popLabel)
        mainStackView.addArrangedSubview(humidityLabel)
        mainStackView.addArrangedSubview(sunriseTimeLabel)
        mainStackView.addArrangedSubview(sunsetTimeLabel)
        mainStackView.addArrangedSubview(spacingView)
    }
    
    private func initialUIData() async {
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutStackView()
        layoutViews()
        setValueToLabel()
        await iconImageView.setIconImage(weatherForecastInfo: weatherForecastInfo, dataFetcher: DataFetcher())
    }
    
    private func layoutViews() {
        mainStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        
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
    
    private func setValueToLabel() {
        weatherGroupLabel.text = weatherForecastInfo.weather.main
        weatherDescriptionLabel.text = weatherForecastInfo.weather.description
        temperatureLabel.text = "현재 기온 : \(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(weatherForecastInfo.main.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(weatherForecastInfo.main.tempMin)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(weatherForecastInfo.main.humidity)%"
        
        if let cityInfo {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = .none
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier:  LocalIdentifier().getLocaleIdentifier())
            sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
    }
}

extension UIImageView {
    func setIconImage(weatherForecastInfo: WeatherForecastInfo, dataFetcher: DataFetchable) async {
        Task {
            let iconName: String = weatherForecastInfo.weather.icon
            let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
            guard let url: URL = URL(string: urlString) else {
                return
            }
            guard let image = await dataFetcher.fetchImage(hashableURL: url) else { return }
            
            self.image = image
        }
    }
}
