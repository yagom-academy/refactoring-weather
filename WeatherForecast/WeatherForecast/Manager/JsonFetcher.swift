//
//  JsonFetcher.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/20/24.
//

import Foundation
import UIKit

struct JSONFetcher {
    static func createData(from asset: String) -> Data? {
        guard let data = NSDataAsset(name: asset)?.data else {
            print(#function, "Not Found Data")
            return nil
        }
        return data
    }
    
    static func decodeJSON<T: Decodable>(data: Data) -> T? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData: T = try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(#function, error.localizedDescription)
            return nil
        }
    }
}
