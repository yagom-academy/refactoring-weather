//
//  WeatherListUseCase.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/3/24.
//

import Foundation

protocol WeatherUseCase {
    func fetchCityWeather(from url: URL) async -> CityWeather?
    func fetchWeatherImage(from url: URL) async -> ImageCache?
}

final class DefaultWeatherUseCase: WeatherUseCase {
    private var weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    convenience init() {
        self.init(
            weatherRepository: DefaultWeatherRepository()
        )
    }
    
    func fetchCityWeather(from url: URL) async -> CityWeather? {
        do {
            let cityWeahter = try await weatherRepository.fetchWeatherList(from: url)
            return cityWeahter
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchWeatherImage(from url: URL) async -> ImageCache? {
        await weatherRepository.fetchImage(from: url)
    }
}
