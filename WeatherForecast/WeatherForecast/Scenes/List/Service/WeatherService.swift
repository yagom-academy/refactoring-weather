//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import UIKit


protocol WeatherService {
    func fetchWeatherService(tempUnit: TempUnit) -> WeatherList?
}


struct WeatherServiceImpl: WeatherService {
    func fetchWeatherService(tempUnit: TempUnit) -> WeatherList? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        let info: WeatherJsonDTO
        do {
            info = try jsonDecoder.decode(WeatherJsonDTO.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }

        return info.toDomain()
    }
}
