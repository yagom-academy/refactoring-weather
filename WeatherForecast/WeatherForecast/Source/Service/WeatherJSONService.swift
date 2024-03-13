//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//

import Foundation
import UIKit

final class WeatherJSONService {
    func fetchWeather(completion: @escaping (WeatherJSON) -> ()) {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSON
        
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        completion(info)
    }
}
