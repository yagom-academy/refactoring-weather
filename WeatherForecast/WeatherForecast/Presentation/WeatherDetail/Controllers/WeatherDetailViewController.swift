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
        let weather: Weather = weatherDetailContext.weather
        configureNaviagtionBar(with: weather)
        configureLabels(with: weather)
        configureImage(with: weather)
    }
    
    private func configureNaviagtionBar(with weather: Weather) {
        navigationItem.title = DateFormatterCreator.createKoreanDateFormatter().string(from: weather.date)
    }
    
    private func configureLabels(with weather: Weather) {
        configureDescriptionLabels(with: weather)
        configureTemperatureLabels(with: weather)
        configureTimeLabels(with: weather)
        configureDetailLabels(with: weather)
    }
    
    private func configureDescriptionLabels(with weather: Weather) {
        weatherDetailView.weatherGroupLabel.text = weather.condition.main
        weatherDetailView.weatherDescriptionLabel.text = weather.condition.description
    }
    
    private func configureTemperatureLabels(with weather: Weather) {
        let tempUnit: TemperatureUnit = weatherDetailContext.tempUnit
        weatherDetailView.temperatureLabel.text = "현재 기온 : \(tempUnit.strategy.convertTemperature(weather.temperature.current))"
        weatherDetailView.feelsLikeLabel.text = "체감 기온 :\(tempUnit.strategy.convertTemperature(weather.temperature.feelsLike))"
        weatherDetailView.maximumTemperatureLable.text = "최고 기온 : \(tempUnit.strategy.convertTemperature(weather.temperature.max))"
        weatherDetailView.minimumTemperatureLable.text = "최저 기온 : \(tempUnit.strategy.convertTemperature(weather.temperature.min))"
    }
    
    private func configureTimeLabels(with weather: Weather) {
        let cityInfo = weatherDetailContext.city
        let formatter: DateFormatter = DateFormatterCreator.createShortKoreanDateFormatter()
        weatherDetailView.sunriseTimeLabel.text = "일출 : \(formatter.string(from: cityInfo.sunrise))"
        weatherDetailView.sunsetTimeLabel.text = "일몰 : \(formatter.string(from: cityInfo.sunset))"
    }
    
    private func configureDetailLabels(with weather: Weather) {
        weatherDetailView.popLabel.text = "강수 확률 : \(weather.pop * 100)%"
        weatherDetailView.humidityLabel.text = "습도 : \(weather.humidity)%"
    }
    
    private func configureImage(with weather: Weather) {
        Task {
            let iconName: String = weather.condition.icon
            guard let url: URL = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png") else { return }
            guard let imageData = await weatherUseCase.fetchWeatherImage(from: url),
            let image = UIImage(data: imageData.data) else { return }
            weatherDetailView.iconImageView.image = image
        }
    }
}
