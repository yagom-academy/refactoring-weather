//
//  WeatherDataSource.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/18/24.
//

import UIKit
import Combine

enum DataSourceError: Error {
    case noData
}

protocol WeatherDataSource {
    func fetchWeatherData() -> Future<Data, Error>
}

struct WeatherDataSourceImpl: WeatherDataSource {
    func fetchWeatherData() -> Future<Data, Error> {
        .init { promise in
            guard let data: Data = NSDataAsset(name: "weather")?.data else {
                promise(.failure(DataSourceError.noData))
                return
            }
            
            promise(.success(data))
        }
    }
}


struct WeatherDataSourceStub: WeatherDataSource {
    func fetchWeatherData() -> Future<Data, Error> {
        .init { promise in
            var data: Data = .init()
            
            promise(.success(data))
        }
    }
}
