//
//  JsonExtract.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation
import UIKit

protocol JsonFileExtractable {
    associatedtype Result
    func extract() -> Result?
}

struct JsonFileExtracter< T: Decodable >: JsonFileExtractable {
    let fileName: String
    
    func extract() -> T? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: fileName)?.data else {
            return nil
        }
        
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


