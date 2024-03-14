//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/14/24.
//

import UIKit

protocol WeatherDetailDelegate: AnyObject {
    func dateDidChanged(text: String)
}

class WeatherDeatilView: UIView {
    private var weatherApi: WeatherApi
    private weak var delegate: WeatherDetailDelegate?
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
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
    
    init(weatherForecastInfo: WeatherForecastInfo, tempUnit: TempUnit, cityInfo: City, weatherApi: WeatherApi, delegate: WeatherDetailDelegate) {
        self.weatherApi = weatherApi
        self.delegate = delegate
        super.init(frame: .zero)
        setUpViews()
        setUpLayout()
        setUpData(weatherForecastInfo: weatherForecastInfo, tempUnit: tempUnit, cityInfo: cityInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = .white
        
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private func setUpLayout() {
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
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
}

extension WeatherDeatilView {
    private func setUpData(weatherForecastInfo: WeatherForecastInfo, tempUnit: TempUnit, cityInfo: City) {
        let weatherForecastInfo = weatherForecastInfo
//        
        setUpData(weatherForecastInfo: weatherForecastInfo, tempExpression: tempUnit.expression)
        setUpData(cityInfo: cityInfo)
        Task {
            await imageTask(imageName: weatherForecastInfo.weather.icon)
        }
    }
    
    private func setUpData(weatherForecastInfo: WeatherForecastInfo?, tempExpression: String) {
        guard let listInfo = weatherForecastInfo else {
            return
        }
        
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempExpression)"
        feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempExpression)"
        maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempExpression)"
        minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempExpression)"
        popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        if let timeInterval = weatherForecastInfo?.dt {
            let date = Date(timeIntervalSince1970: timeInterval)
            delegate?.dateDidChanged(text: dateFormatter.string(from: date))
        }
    }
    
    private func setUpData(cityInfo: City?) {
        guard let cityInfo else {
            return
        }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
        sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
    }
    
    private func imageTask(imageName: String?) async {
        guard let imageName else {
            return
        }
        
        let image = await weatherApi.fetchImage(iconName: imageName)
        self.iconImageView.image = image
    }
}
