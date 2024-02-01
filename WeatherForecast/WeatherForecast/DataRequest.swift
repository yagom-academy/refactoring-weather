//
//  DataRequest.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation

protocol DataRequestable {
    func request(urlString: String) async throws -> Data
}

struct DataRequester: DataRequestable {
    
    func request(urlString: String) async throws -> Data {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            throw NSError() 
        }
        return data
    }
}
