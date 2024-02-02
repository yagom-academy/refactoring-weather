//
//  DataAssetProvider.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

final class DataAssetProvider: DataAssetProviderService {
  static let shared: DataAssetProviderService = DataAssetProvider()
  private let jsonDecodeHelper: JSONDecodeHelperProtocol = JSONDecodeHelper()
  private init() { }
}

extension DataAssetProvider {
  func data<T: Decodable>(
    _ type: T.Type,
    name from: String
  ) -> Result<T, Error> {
    var result: Result<T, Error>
    let dataResult = dataAsset(name: from)
    let data = dataResult
      .flatMap { return jsonDecodeHelper.decode(type, from: $0) }
    switch data {
    case .success(let decodedData):
      result = .success(decodedData)
    case .failure(_):
      result = .failure(NSError())
    }
    
    return result
  }
}

extension DataAssetProvider {
  private func dataAsset(name from: String) -> Result<Data, Error> {
    var result: Result<Data, Error>
    
    if let data = NSDataAsset(name: from)?.data {
      result = .success(data)
    } else {
      result = .failure(NSError())
    }
    
    return result
  }
}
