//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by 강동영 on 1/31/24.
//

import UIKit

final class WeatherDetailView: UIView {
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
    
    let dataFetcher: DataFetchable

    lazy var mainStackView: UIStackView = .init(arrangedSubviews: [
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
    
    init(weatherForecastInfo: WeatherForecastInfo, dataFetcher: DataFetchable) {
        self.weatherForecastInfo = weatherForecastInfo
        self.dataFetcher = dataFetcher
        super.init(frame: .zero)
        
        backgroundColor = .white
        initialUIData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City?
    var tempUnit: TempUnit = .celsius
}

extension WeatherDetailView {
    
    private func initialUIData() {
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutViews()
        setValueToLabel()
        setIconImage()
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
            formatter.locale = .init(identifier: "ko_KR")
            sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
    }
    
    private func setIconImage() {
        Task {
            let iconName: String = weatherForecastInfo.weather.icon
            let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
            
            // DataFetcher 구조체로 옮김
            //        SRP에 위반되는것 같음.
            //        근데 어떻게 async한 Task를 따로 메서드로 분리할지 잘 모르겠음...
//            guard let url: URL = URL(string: urlString),
//                  let (data, _) = try? await URLSession.shared.data(from: url),
//                  let image: UIImage = UIImage(data: data) else {
//                return
//            }
            guard let url: URL = URL(string: urlString) else {
                return
            }
            guard let image = await dataFetcher.fetchImage(hashableURL: url) else { return }
            
            iconImageView.image = image
        }
    }
}
