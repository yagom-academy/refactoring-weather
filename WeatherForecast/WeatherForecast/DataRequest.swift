//
//  DataRequest.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation

protocol DataRequestable {
    func request(urlString: String) async -> Data?
}

struct DataRequest: DataRequestable {
    
    func request(urlString: String) async -> Data? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            return nil
        }
        return data
    }
}
