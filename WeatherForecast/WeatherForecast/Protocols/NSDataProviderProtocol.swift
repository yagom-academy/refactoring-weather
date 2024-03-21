//
//  NSDataProviderProtocol.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/18/24.
//

import UIKit

protocol NSDataProviderProtocol {
  func fetchWeatherData() -> Result<Data, NSDataProviderError>
}

extension NSDataProviderProtocol {
  func fetchWeatherData() -> Result<Data, NSDataProviderError> {
    guard let data = NSDataAsset(name: "weather")?.data else {
      return .failure(.notFoundData)
    }
    
    return .success(data)
  }
}
