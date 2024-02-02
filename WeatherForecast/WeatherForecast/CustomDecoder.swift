//
//  CustomDecoder.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

protocol CustomDecodable {
    func decode<T: Decodable>(_ decodable: T.Type, data from: Data?) throws -> T
}

struct CustomDecoder: CustomDecodable {
    enum DecoderError: Error {
        case dataIsNil
        case catchError(Error)
    }
    
    func decode<T: Decodable>(_ decodable: T.Type, data from: Data?) throws -> T {
        guard let data = from else { throw DecoderError.dataIsNil }
        do {
            let jsonDecoder: JSONDecoder = .init()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoder = try jsonDecoder.decode(decodable.self, from: data)
            return decoder
        } catch {
            throw DecoderError.catchError(error)
        }
    }
}
