//
//  ImageProvider.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

final actor ImageProvider: ImageProviderService {
  static let shared: ImageProviderService  = ImageProvider()
  private var cachedImage: NSCache<NSString, UIImage> = NSCache()
  private let imageDownLoader: ImageDownLoaderService = ImageDownLoader()
  private init() { }
}

extension ImageProvider {
  func image(
    url: String,
    placeHoler: UIImage? = nil
  ) async -> UIImage? {
    if let cachedImage = cachedImage.object(forKey: url as NSString) {
      return cachedImage
    } else {
      return await downLoadImage(
        url: url,
        placeHoler: placeHoler
      )
    }
  }
}

extension ImageProvider {
  private func downLoadImage(
    url: String,
    placeHoler: UIImage?
  ) async -> UIImage? {
    let result = await imageDownLoader.image(url: url)
    switch result {
    case .success(let image):
      cachedImage.setObject(image, forKey: url as NSString)
      return image
    case .failure(_):
      return placeHoler
    }
  }
}
