//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/5/24.
//

import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String) throws -> T?
}

final class WeatherDataManager: WeatherDataManagerDelegate {

    func fetchWeatherData<T: Decodable>(jsonDecoder: JSONDecoder,
                                        dataAsset: String
    ) throws -> T? {
        guard let data = NSDataAsset(name: dataAsset)?.data else {
            return nil
        }
        
        do {
            let info: T = try jsonDecoder.decode(T.self, from: data)
            return info
        } catch {
            throw error
        }
    }
}
