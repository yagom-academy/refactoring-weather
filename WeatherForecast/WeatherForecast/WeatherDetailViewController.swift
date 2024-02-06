//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    
    let iconImageView: UIImageView = .init()
    let weatherGroupLabel: UILabel = .init()
    let weatherDescriptionLabel: UILabel = .init()
    let temperatureLabel: UILabel = .init()
    let feelsLikeLabel: UILabel = .init()
    let maximumTemperatureLable: UILabel = .init()
    let minimumTemperatureLable: UILabel = .init()
    let popLabel: UILabel = .init()
    let humidityLabel: UILabel = .init()
    let sunriseTimeLabel: UILabel = .init()
    let sunsetTimeLabel: UILabel = .init()
    let spacingView: UIView = .init()
    var weatherInfo: WeatherDetailInfo
    var cityInfo: CityDetailInfo
    var mainInfo: MainDetailInfo
    var tempUnit: TempUnit
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
  
    init(weatherInfo: WeatherDetailInfo, mainInfo: MainDetailInfo, cityInfo: CityDetailInfo, tempUnit: TempUnit) {
        self.weatherInfo = weatherInfo
        self.mainInfo = mainInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        updateWeatherInfo(listInfo: weatherInfo, mainInfo: mainInfo, tempUnit: tempUnit)
        updateCityInfo(cityInfo)
        Task {
            await updateWeatherIcon(iconName: weatherInfo.iconImageUrl)
        }
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white
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
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
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

extension WeatherDetailViewController {
    
    func updateWeatherInfo(listInfo: WeatherDetailInfo, mainInfo: MainDetailInfo,tempUnit: TempUnit){
        
        navigationItem.title = listInfo.date
        weatherGroupLabel.text = listInfo.mainWeather
        weatherDescriptionLabel.text = listInfo.description
        temperatureLabel.text = "현재 기온 : \(mainInfo.currentTemp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(mainInfo.feelsLikeTemp)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(mainInfo.maxTemp)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(mainInfo.minTemp)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(mainInfo.pop * 100)%"
        humidityLabel.text = "습도 : \(mainInfo.humidity)%"
    }
    @MainActor
    func updateWeatherIcon(iconName: String) async {
        if let iconImage = await TransforJSON.shared.fetchWeatherIconImage(iconName: iconName) {
            self.iconImageView.image = iconImage
        }
    }
    func updateCityInfo(_ cityInfo: CityDetailInfo) {
        sunriseTimeLabel.text = "일출 : \(cityInfo.sunrise)"
        sunsetTimeLabel.text = "일몰 : \(cityInfo.sunset)"
    }
   
}
