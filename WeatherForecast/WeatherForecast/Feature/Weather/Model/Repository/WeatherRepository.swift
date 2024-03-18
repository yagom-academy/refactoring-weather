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
    private let dataSource: WeatherDataSource
    private let decoder: DataDecoder
    
    init(
        dataSource: WeatherDataSource,
        decoder: DataDecoder
    ) {
        self.dataSource = dataSource
        self.decoder = decoder
    }
    
    func fetchWeather() -> AnyPublisher<FetchWeatherResult, Error> {
        dataSource.fetchWeatherData()
            .flatMap {
                decoder.decode(type: FetchWeatherResultDTO.self, from: $0)
            }
            .map {
                .init(dto: $0)
            }
            .eraseToAnyPublisher()
    }
}
