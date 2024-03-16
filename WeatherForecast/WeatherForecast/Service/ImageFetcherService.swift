//
//  ImageFetcherService.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/14/24.
//

import Foundation

protocol ImageFetcherServiceable {
  func execute(from url: URL) async throws -> Data
}

struct ImageFetcherService: ImageFetcherServiceable {
  func execute(from url: URL) async throws -> Data {
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        throw ImageFetcherError.failedToCastingResponse
      }
      
      guard (200..<300).contains(statusCode) else {
        throw ImageFetcherError.invalidStatusCode(statusCode: statusCode)
      }
      
      return data
    } catch {
      throw ImageFetcherError.invalidData
    }
  }
}
