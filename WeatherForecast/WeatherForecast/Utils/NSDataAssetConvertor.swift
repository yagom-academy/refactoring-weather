//
//  NSDataAssetConvertor.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import UIKit

protocol NSDataAssetConvertable {
    //  func data(_ name: String) throws -> Data
    func fetchNSData(_ name: String) throws -> Data
}


enum NSDataConvertorError: Error {
    case unknownDataAsset
}

//struct NSDataAssetConvertor: NSDataAssetConvertable {
// dataFetcher 구조체로 이전
//  func data(_ name: String) throws -> Data {
//    guard let dataAsset = NSDataAsset(name: name) else { throw NSDataConvertorError.unknownDataAsset }
//    return dataAsset.data
//  }
//}
