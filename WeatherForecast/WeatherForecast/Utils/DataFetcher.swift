//
//  DataFetcher.swift
//  WeatherForecast
//
//  Created by user on 2/8/24.
//

import Foundation
import UIKit


protocol WeatherJSONFetchable {
    func fetchWeatherJSON() -> WeatherJSON?
}

protocol ImageFetchable {
    func fetchImage(hashableURL: any Hashable) async -> UIImage?
}

protocol NSDataAssetFetchable {
    func fetchNSAssetData(_ name: String) throws -> Data
}

enum NSDataConvertorError: Error {
    case unknownDataAsset
}



typealias Fetchable = WeatherJSONFetchable & ImageFetchable & NSDataAssetFetchable

protocol DataFetchable: Fetchable {
    var decoder: CustomDecodable { get }
}

struct DataFetcher: DataFetchable {
    internal let decoder: CustomDecodable = CustomDecoder(jsonDecoder: JSONDecoder())
    
    func fetchWeatherJSON() -> WeatherJSON? {
        guard let data = try? self.fetchNSAssetData("weather"),
              let response = try? decoder.decode(WeatherJSON.self, data: data)
        else { return nil }
        
        return response
    }
    
    func fetchImage(hashableURL: any Hashable) async -> UIImage? {
        guard let urlString = hashableURL as? String else { return nil }
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func fetchNSAssetData(_ name: String) throws -> Data {
        guard let dataAsset = NSDataAsset(name: name) else { throw NSDataConvertorError.unknownDataAsset }
      return dataAsset.data
    }
}
