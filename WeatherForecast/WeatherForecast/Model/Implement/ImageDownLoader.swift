//
//  ImageDownLoader.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

struct ImageDownLoader: ImageDownLoaderService {
  func image(url: String) async -> Result<UIImage, Error> {
    var result: Result<UIImage, Error>
    
    guard let url = URL(string: url),
          let (data, _) = try? await URLSession.shared.data(from: url),
          let image = UIImage(data: data) else {
      result = .failure(NSError())
      return result
    }
    
    result = .success(image)
    return result
  }
}
