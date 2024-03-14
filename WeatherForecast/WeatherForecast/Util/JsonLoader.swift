//
//  JsonLoader.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/13/24.
//

import Foundation
import UIKit

class JsonLoader {
    private let jsonDecoder: JSONDecoder
    
    init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetchJson<T: Decodable>(filename: String) -> T? {
        guard let data: Data = loadJson(filename: filename),
              let info: T = decodeJson(data: data)
        else {
            return nil
        }
        
        return info
    }
    
    private func loadJson(filename: String) -> Data?{
        guard let data = NSDataAsset(name: filename)?.data else {
            debugPrint("json file {\(filename)} wasn't able to load")
            return nil
        }
        return data
    }
    
    private func decodeJson<T: Decodable>(data: Data) -> T? {
        let info: T
        
        do {
            info = try jsonDecoder.decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return info
    }
}
