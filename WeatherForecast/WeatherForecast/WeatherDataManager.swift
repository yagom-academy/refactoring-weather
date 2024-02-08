//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/5/24.
//

import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String) throws -> T
}

enum WeatherManagerError: Error {
    case failDataAssetInit
}

final class WeatherDataManager: WeatherDataManagerDelegate {

    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String
    ) throws -> T {
        guard let data = NSDataAsset(name: dataAsset)?.data else {
            throw WeatherManagerError.failDataAssetInit
        }
        
        do {
            let info: T = try jsonDecoder.decode(T.self, from: data)
            return info
        } catch {
            throw error
        }
    }
}
