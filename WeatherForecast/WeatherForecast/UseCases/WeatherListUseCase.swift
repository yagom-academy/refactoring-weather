//
//  WeatherListUseCase.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/3/24.
//

import Foundation

protocol WeatherListUseCase {
    func fetchWeatherList(url: URL?) -> CityWeather?
}

final class DefaultWeatherListUseCase: WeatherListUseCase {
    func fetchWeatherList(url: URL?) -> CityWeather? {
        let jsonDecoder: JSONDecoder = JSONDecoderCreator.createSnakeCaseDecoder()

        guard let url: URL = url else { return nil }
        let info: CityWeather
        
        do {
            let data: Data = try Data(contentsOf: url)
            info = try jsonDecoder.decode(CityWeather.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return info
    }
}
