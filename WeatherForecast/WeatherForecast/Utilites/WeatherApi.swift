//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/13/24.
//

import UIKit

protocol WeatherApi {
    var imageLoader: ImageLoadable { get }
    func fetchData() async throws -> WeatherJSON
    func fetchImage(iconName: String) async -> UIImage?
    func iconImageUrlString(iconName: String) -> String
}

enum ApiError: Error {
    case invalidData
    case failedDecode
}

final class OpenWeatherAPI: WeatherApi {
    let imageLoader: ImageLoadable
    
    init(imageLoader: ImageLoadable) {
        self.imageLoader = imageLoader
    }
    
    func fetchData() async throws -> WeatherJSON {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            throw ApiError.invalidData
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            throw ApiError.failedDecode
        }
        
        return info
    }
    
    func fetchImage(iconName: String) async -> UIImage? {
        let urlString: String = iconImageUrlString(iconName: iconName)
        do {
            return try await imageLoader.fetchImage(wtih: urlString)
        } catch {
            return nil
        }
    }
    
    func iconImageUrlString(iconName: String) -> String {
        return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
}


