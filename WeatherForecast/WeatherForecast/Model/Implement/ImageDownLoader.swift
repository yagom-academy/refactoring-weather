//
//  ImageDownLoader.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

struct ImageDownLoader: ImageDownLoaderService {
  @MainActor
  func image(url: String) async -> Result<UIImage, Error> {
    var result: Result<UIImage, Error>
    
    guard let url = URL(string: url) else {
      result = .failure(NSError())
      return result
    }
    
    var image: UIImage?
    
    await withTaskGroup(of: UIImage?.self) { imageTaskGroup in
      imageTaskGroup.addTask(
        priority: .background) {
          guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            return nil
          }
          return UIImage(data: data)
        }
      
      for await loadedImage in imageTaskGroup {
        image = loadedImage
      }
    }
    
    if let image = image {
      result = .success(image)
    } else {
      result = .failure(NSError())
    }
    
    return result
  }
}
