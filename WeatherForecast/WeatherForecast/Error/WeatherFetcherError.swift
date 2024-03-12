//
//  WeatherFetcherError.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/13/24.
//

import Foundation

enum WeatherFetcherError: Error {
  case notFoundData
  case decodingFailed
}
