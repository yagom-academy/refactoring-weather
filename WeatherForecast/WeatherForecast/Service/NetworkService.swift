//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/3/24.
//

import UIKit

protocol NetworkFetchable {
    func fetchWeatherJSON() -> Result<Weather, Error>
}

final class NetworkService: NetworkFetchable {
    func fetchWeatherJSON() -> Result<Weather, Error> {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data: Data = NSDataAsset(name: "weather")?.data else {
            return .failure(NetworkError.invalidData)
        }
        
        let info: WeatherJSONDTO
        do {
            info = try jsonDecoder.decode(WeatherJSONDTO.self, from: data)
        } catch {
            print(error.localizedDescription)
            return .failure(NetworkError.decodingError)
        }
        
        return .success(info.toEntity())
    }
}
