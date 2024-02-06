//
//  WeatherIconImageService.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import UIKit

final class WeatherIconImageService: NetworkService {
    private let imageChache: NSCache<NSString, UIImage> = NSCache()

    func fetchImage(iconName: String,
                    urlSession: URLSession) async throws -> UIImage {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"

        guard let url: URL = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await urlSession.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.networkFail
        }
        
        guard let image: UIImage = UIImage(data: data) else {
            throw NetworkError.invalidData
        }
        
        imageChache.setObject(image, forKey: urlString as NSString)
        
        return image
    }
}
