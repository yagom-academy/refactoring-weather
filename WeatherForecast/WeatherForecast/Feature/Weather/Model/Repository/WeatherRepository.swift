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
    func fetchWeather() -> AnyPublisher<FetchWeatherResult, Error> {
        return Future<FetchWeatherResult, Error> { promise in
            let jsonDecoder: JSONDecoder = .init()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let data = NSDataAsset(name: "weather")?.data else {
                return
            }
            
            do {
                let info: FetchWeatherResultDTO = try jsonDecoder.decode(FetchWeatherResultDTO.self, from: data)
                promise(.success(.init(dto: info)))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
