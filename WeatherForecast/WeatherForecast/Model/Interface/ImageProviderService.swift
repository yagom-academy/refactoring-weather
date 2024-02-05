//
//  ImageProviderService.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

protocol ImageProviderService: AnyObject {
  func image(
    url: String,
    placeHoler: UIImage?
  ) async -> UIImage?
}

extension ImageProviderService {
  func image(
    url: String,
    placeHoler: UIImage? = nil
  ) async -> UIImage? {
    await image(
      url: url,
      placeHoler: placeHoler
    )
  }
}
