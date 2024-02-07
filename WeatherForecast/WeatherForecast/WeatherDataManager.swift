//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/5/24.
//

import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String,
                                        completion: @escaping (Result<T, Error>) -> Void)
}

final class WeatherDataManager: WeatherDataManagerDelegate {

    
    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String,
                                        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let data = NSDataAsset(name: dataAsset)?.data else {
            return
        }
        
        do {
            let info: T = try jsonDecoder.decode(T.self, from: data)
            completion(.success(info))
        } catch {
            completion(.failure(error))
        }
    }
}
