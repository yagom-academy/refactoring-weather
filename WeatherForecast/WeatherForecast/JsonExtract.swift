//
//  JsonExtract.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation
import UIKit

protocol JsonExtractable {
    associatedtype Result
    func extract() -> Result?
}

struct WeatherJsonExtracter: JsonExtractable {
    func extract() -> WeatherJSON? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return info
    }
}


