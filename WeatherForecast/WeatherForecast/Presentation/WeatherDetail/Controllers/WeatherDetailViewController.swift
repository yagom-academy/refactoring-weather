//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    private let weatherDetailView: WeatherDetailView = WeatherDetailView()
    private let weatherUseCase: WeatherUseCase
    private let weatherDetailContext: WeatherDetailContext
    
    init(weatherUseCase: WeatherUseCase, context: WeatherDetailContext) {
        self.weatherUseCase = weatherUseCase
        self.weatherDetailContext = context
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(contenxt: WeatherDetailContext) {
        self.init(weatherUseCase: DefaultWeatherUseCase(), context: contenxt)
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    override func loadView() {
        view = weatherDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}


// MARK: Configure UI
extension WeatherDetailViewController {
    private func configureUI() {
        let weatherForecastInfo: WeatherForecastInfo = weatherDetailContext.weatherForecastInfo
        configureNaviagtionBar(with: weatherForecastInfo)
        configureLabels(with: weatherForecastInfo)
        configureImage(with: weatherForecastInfo)
    }
    
    private func configureNaviagtionBar(with weatherForecastInfo: WeatherForecastInfo) {
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = DateFormatterCreator.createKoreanDateFormatter().string(from: date)
    }
    
    private func configureLabels(with weatherForecastInfo: WeatherForecastInfo) {
        configureDescriptionLabels(with: weatherForecastInfo)
        configureTemperatureLabels(with: weatherForecastInfo)
        configureTimeLabels(with: weatherForecastInfo)
        configureDetailLabels(with: weatherForecastInfo)
    }
    
    private func configureDescriptionLabels(with weatherForecastInfo: WeatherForecastInfo) {
        weatherDetailView.weatherGroupLabel.text = weatherForecastInfo.weather.main
        weatherDetailView.weatherDescriptionLabel.text = weatherForecastInfo.weather.description
    }
    
    private func configureTemperatureLabels(with weatherForecastInfo: WeatherForecastInfo) {
        let tempUnit: TemperatureUnit = weatherDetailContext.tempUnit
        weatherDetailView.temperatureLabel.text = "현재 기온 : \(tempUnit.strategy.convertTemperature(weatherForecastInfo.main.temp))"
        weatherDetailView.feelsLikeLabel.text = "체감 기온 :\(tempUnit.strategy.convertTemperature(weatherForecastInfo.main.feelsLike))"
        weatherDetailView.maximumTemperatureLable.text = "최고 기온 : \(tempUnit.strategy.convertTemperature(weatherForecastInfo.main.tempMax))"
        weatherDetailView.minimumTemperatureLable.text = "최저 기온 : \(tempUnit.strategy.convertTemperature(weatherForecastInfo.main.tempMin))"
    }
    
    private func configureTimeLabels(with weatherForecastInfo: WeatherForecastInfo) {
        let cityInfo = weatherDetailContext.cityInfo
        let formatter: DateFormatter = DateFormatterCreator.createShortKoreanDateFormatter()
        weatherDetailView.sunriseTimeLabel.text = "일출 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
        weatherDetailView.sunsetTimeLabel.text = "일몰 : \(formatter.string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
    }
    
    private func configureDetailLabels(with weatherForecastInfo: WeatherForecastInfo) {
        weatherDetailView.popLabel.text = "강수 확률 : \(weatherForecastInfo.main.pop * 100)%"
        weatherDetailView.humidityLabel.text = "습도 : \(weatherForecastInfo.main.humidity)%"
    }

    
    private func configureImage(with weatherForecastInfo: WeatherForecastInfo) {
        Task {
            let iconName: String = weatherForecastInfo.weather.icon
            let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
            guard let imageData = await weatherUseCase.fetchWeatherImage(url: urlString),
            let image = UIImage(data: imageData.data) else { return }
            weatherDetailView.iconImageView.image = image
        }
    }
}
