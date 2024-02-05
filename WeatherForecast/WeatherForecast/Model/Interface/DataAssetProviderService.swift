//
//  DataAssetProviderService.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import Foundation

protocol DataAssetProviderService: AnyObject {
  func data<T: Decodable>(
    _ type: T.Type,
    name from: String
  ) -> Result<T, Error>
}
