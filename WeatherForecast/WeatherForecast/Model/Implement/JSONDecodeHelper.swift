//
//  JSONDecodeHelper.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import Foundation

struct JSONDecodeHelper: JSONDecodeHelperProtocol {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func decode<T: Decodable>(
      _ type: T.Type,
      from data: Data
    ) -> Result<T, Error> {
      var result: Result<T, Error>
      
      do {
        let decodeDate = try jsonDecoder.decode(
          type,
          from: data
        )
        result = .success(decodeDate)
      } catch {
        result = .failure(error)
      }
        
      return result
    }
}
