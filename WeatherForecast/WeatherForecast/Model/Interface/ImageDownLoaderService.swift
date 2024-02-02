//
//  ImageDownLoaderService.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

protocol ImageDownLoaderService {
  func image(url: String) async -> Result<UIImage, Error>
}
