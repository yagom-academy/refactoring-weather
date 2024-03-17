//
//  WeatherImageCacheService.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import UIKit

protocol WeatherImageCacheServiceable {
  func execute(iconName: String) async throws -> UIImage
}

struct WeatherImageCacheService: WeatherImageCacheServiceable {
  private let service: HTTPSessionServiceable
  private let cache: NSCache<NSString, UIImage> = .init()
  
  init(service: HTTPSessionServiceable) {
    self.service = service
  }
  
  func execute(iconName: String) async throws -> UIImage {
    let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    
    guard let url: URL = .init(string: urlString) else {
      throw ImageCacheError.invalidURL
    }
    
    if let image: UIImage = cache.object(forKey: urlString as NSString) {
      return image
    }
    
    let imageData = try await service.downloadData(from: url)
    
    guard let image: UIImage = .init(data: imageData) else {
      throw ImageCacheError.failedToConvertImage
    }
    
    cache.setObject(image, forKey: urlString as NSString)
    return image
  }
}
