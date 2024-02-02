//
//  NSDataAssetConvertor.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import UIKit

protocol NSDataAssetConvertable {
  func data(_ name: String) throws -> Data
}

struct NSDataAssetConvertor: NSDataAssetConvertable {
  enum NSDataConvertorError: Error {
    case unknownDataAsset
  }

  func data(_ name: String) throws -> Data {
    guard let dataAsset = NSDataAsset(name: name) else { throw NSDataConvertorError.unknownDataAsset }
    return dataAsset.data
  }
}
