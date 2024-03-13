//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    private let weatherForecastInfo: WeatherForecastInfo
    private let cityInfo: City
    private let tempUnit: TempUnit
    private let contentView = WeatherDetailView()
    
    private let imageService: WeatherImageService
    
    init(weatherForecastInfo: WeatherForecastInfo, 
         cityInfo: City,
         tempUnit: TempUnit,
         imageService: WeatherImageService) {
        
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        self.imageService = imageService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white
        contentView.spacingView.backgroundColor = .clear
        contentView.spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentView.weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        contentView.weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        let listInfo = weatherForecastInfo
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = DateFormatter.convertToKorean(by: date)

        contentView.weatherGroupLabel.text = listInfo.weather.main
        contentView.weatherDescriptionLabel.text = listInfo.weather.description
        contentView.temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempUnit.symbol)"
        contentView.feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempUnit.symbol)"
        contentView.maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempUnit.symbol)"
        contentView.minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempUnit.symbol)"
        contentView.popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        contentView.humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        let sunriseDate = Date(timeIntervalSince1970: cityInfo.sunrise)
        let sunsetDate = Date(timeIntervalSince1970: cityInfo.sunset)
        
        contentView.sunriseTimeLabel.text = "일출 : \(DateFormatter.convertToCityTime(by: sunriseDate))"
        contentView.sunsetTimeLabel.text = "일몰 : \(DateFormatter.convertToCityTime(by: sunsetDate))"
        
        let iconName: String = listInfo.weather.icon
        
        imageService.fetchImage(iconName: iconName) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                contentView.iconImageView.image = image
            }
        }
    }
}
