//
//  ImageFetcherError.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import Foundation

enum ImageFetcherError: Error {
  case failedToCastingResponse
  case invalidStatusCode(statusCode: Int)
  case invalidData
}
