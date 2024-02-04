//
//  JSONDecoderCreator.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/4/24.
//

import Foundation

struct JSONDecoderCreator {
    static func createSnakeCaseDecoder() -> JSONDecoder {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return jsonDecoder
    }
}
