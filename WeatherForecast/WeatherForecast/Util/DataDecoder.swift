//
//  DataDecoder.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/18/24.
//

import Foundation
import Combine

protocol DataDecoder {
    func decode<Item>(type: Item.Type, from: Data) -> AnyPublisher<Item, Error> where Item : Decodable
}

struct DataDecoderJSON: DataDecoder {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
        
        setUpDecoder()
    }
    
    private func setUpDecoder() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func decode<Item>(type: Item.Type, from: Data) -> AnyPublisher<Item, Error> where Item : Decodable {
        Just(from)
            .decode(type: Item.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
