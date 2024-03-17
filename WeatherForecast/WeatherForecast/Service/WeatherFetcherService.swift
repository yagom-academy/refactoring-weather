//
//  WeatherFetcherService.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/13/24.
//

import UIKit

protocol WeatherFetcherServiceable {
  func execute() -> Result<WeatherJSON, WeatherFetcherError>
}

final class WeatherFetcherService: WeatherFetcherServiceable, NSDataProviderProtocol {
  func execute() -> Result<WeatherJSON, WeatherFetcherError> {
    let jsonDecoder: JSONDecoder = .init()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let fetchResult = fetchWeatherData()
    
    switch fetchResult {
    case .success(let data):
      do {
        let info: WeatherJSON = try jsonDecoder.decode(WeatherJSON.self, from: data)
        return .success(info)
      } catch {
        print(error.localizedDescription)
        return .failure(.failedToDecode)
      }
    case .failure(let error):
      print(error)
      return .failure(.notFoundData)
    }
  }
}
