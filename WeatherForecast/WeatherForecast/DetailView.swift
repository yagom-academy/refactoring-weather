//
//  DetailView.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/18/24.
//

import UIKit

class DetailView: UIView {
    let weatherForecastInfo: WeatherForecastInfo
    let cityInfo: City
    var tempUnit: TempUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        
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
            weatherGroupLabel.text = weatherForecastInfo.weather.main
            weatherDescriptionLabel.text = weatherForecastInfo.weather.description
            temperatureLabel.text = "현재 기온 : \(weatherForecastInfo.main.temp)\(tempUnit.expression)"
            feelsLikeLabel.text = "체감 기온 : \(weatherForecastInfo.main.feelsLike)\(tempUnit.expression)"
            maximumTemperatureLable.text = "최고 기온 : \(weatherForecastInfo.main.tempMax)\(tempUnit.expression)"
            minimumTemperatureLable.text = "최저 기온 : \(weatherForecastInfo.main.tempMin)\(tempUnit.expression)"
            popLabel.text = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
            humidityLabel.text = "습도 : \(weatherForecastInfo.main.humidity)%"
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = .none
            formatter.timeStyle = .short
            formatter.locale = .init(identifier: "ko_KR")
            sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
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
        Task {
            let iconName: String = weatherForecastInfo.weather.icon
            let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
            
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageView.image = image
        }
    }
}
