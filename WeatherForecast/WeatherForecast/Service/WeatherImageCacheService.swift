//
//  WeatherImageCacheService.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import UIKit

protocol WeatherImageCacheServiceable {
  func fetchImage(iconName: String) async throws -> UIImage
}

final class WeatherImageCacheService: WeatherImageCacheServiceable {
  private let service: HTTPSessionServiceable
  private var cache: ImageCachable
  
  init(
    service: HTTPSessionServiceable,
    cache: ImageCachable = ImageCache()
  ) {
    self.service = service
    self.cache = cache
  }
  
  func fetchImage(iconName: String) async throws -> UIImage {
    let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    
    if let image: UIImage = cache[urlString] {
      return image
    }
    
    guard let url: URL = .init(string: urlString) else {
      throw ImageCacheError.invalidURL
    }
    
    let imageData = try await service.downloadData(from: url)
    
    guard let image: UIImage = .init(data: imageData) else {
      throw ImageCacheError.failedToConvertImage
    }
    
    cache[urlString] = image
    return image
  }
}
