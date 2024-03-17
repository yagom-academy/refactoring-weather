//
//  HTTPSessionServiceError.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import Foundation

enum HTTPSessionServiceError: Error {
  case noHTTPResponse
  case invalidStatusCode(statusCode: Int)
  case networkError(error: Error)
}
