//
//  HTTPSessionService.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import Foundation

protocol HTTPSessionServiceable {
  func downloadData(from url: URL) async throws -> Data
}

struct HTTPSessionService: HTTPSessionServiceable {
  func downloadData(from url: URL) async throws -> Data {
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        throw HTTPSessionServiceError.noHTTPResponse
      }
      
      guard (200..<300).contains(statusCode) else {
        throw HTTPSessionServiceError.invalidStatusCode(statusCode: statusCode)
      }
      
      return data
    } catch {
      throw HTTPSessionServiceError.networkError(error: error)
    }
  }
}
