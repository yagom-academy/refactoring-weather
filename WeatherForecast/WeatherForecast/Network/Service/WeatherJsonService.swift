//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import UIKit

final class WeatherJsonService: JsonService {
    func fetchWeatherJSON() -> Result<WeatherJSON, JsonError> {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return .failure(.emptyData)
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
            return .success(info)
        } catch {
            return .failure(.failDecode)
        }
    }
}
