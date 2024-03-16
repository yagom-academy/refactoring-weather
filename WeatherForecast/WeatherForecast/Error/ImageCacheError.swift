//
//  ImageCacheError.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import Foundation

enum ImageCacheError: Error {
  case invalidURL
  case failedToConvertImage
}
