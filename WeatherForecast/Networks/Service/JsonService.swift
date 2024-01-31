//
//  JsonService.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import UIKit

final class JsonService: JsonServiceable {
    
    func fetchWeatherJSON() -> Result<WeatherJSON, Error> {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return .failure(JsonServiceError.jsonNotExist)
        }
        
        let weatherInfo: WeatherJSON
        do {
            weatherInfo = try jsonDecoder.decode(WeatherJSON.self, from: data)
            return .success(weatherInfo)
        } catch {
            print(error.localizedDescription)
            return .failure(JsonServiceError.decodeError)
        }
    }
}
