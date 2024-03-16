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

final class WeatherFetcherService: WeatherFetcherServiceable {
  func execute() -> Result<WeatherJSON, WeatherFetcherError> {
    let jsonDecoder: JSONDecoder = .init()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    guard let data = NSDataAsset(name: "weather")?.data else {
      return .failure(.notFoundData)
    }
    
    do {
      let info: WeatherJSON = try jsonDecoder.decode(WeatherJSON.self, from: data)
      return .success(info)
    } catch {
      print(error.localizedDescription)
      return .failure(.failedToDecode)
    }
  }
}
