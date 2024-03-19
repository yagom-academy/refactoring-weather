//
//  WeatherListUsecase.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/20/24.
//

import Foundation
import UIKit

protocol WeatherUseCase {
  func fetchWeather() -> WeatherJSON?
  func fetchImage(from iconName: String) async -> UIImage?
}

final class WeatherUseCaseImpl: WeatherUseCase {
  private let weatherFetcherService: WeatherFetcherServiceable
  private let weatherImageCacheService: WeatherImageCacheServiceable
  
  init(
      weatherFetcherService: WeatherFetcherServiceable,
      weatherImageCacheService: WeatherImageCacheServiceable
  ) {
    self.weatherFetcherService = weatherFetcherService
    self.weatherImageCacheService = weatherImageCacheService
  }
  
  func fetchWeather() -> WeatherJSON? {
    let result = weatherFetcherService.fetchWeather()
    switch result {
    case .success(let weatherJson):
      return weatherJson
    case .failure(let error):
      print(error.localizedDescription)
      return nil
    }
  }
  
  func fetchImage(from iconName: String) async -> UIImage? {
    do {
      let image = try await weatherImageCacheService.execute(iconName: iconName)
      return image
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
