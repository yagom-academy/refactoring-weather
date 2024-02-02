//
//  JSONDecodeHelperProtocol.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import Foundation

protocol JSONDecodeHelperProtocol {
  func decode<T: Decodable>(
    _ type: T.Type,
    from data: Data
  ) -> Result<T, Error>
}
