//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit
import Combine

protocol WeatherRepository {
    func fetchWeather() -> AnyPublisher<FetchWeatherResult, Error>
}

struct WeatherRepositoryImpl: WeatherRepository {
    private var dataSource: WeatherDataSource
    
    init(dataSource: WeatherDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchWeather() -> AnyPublisher<FetchWeatherResult, Error> {
        dataSource.fetchWeatherData()
            .decode(type: FetchWeatherResultDTO.self, decoder: JSONDecoder())
            .map({ .init(dto: $0) })
            .eraseToAnyPublisher()
    }
}
