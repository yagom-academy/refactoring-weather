//
//  IconService.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import UIKit

struct ImageService: ImageServiceable {
    private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func getIcon(iconName: String,
                 urlSession: URLSession,
                 completion: @escaping (Result<UIImage, Error>) -> ()) {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        if let image = imageChache.object(forKey: urlString as NSString) {
            completion(.success(image))
            return
        }
        
        Task {
            guard let url: URL = URL(string: urlString) else {
                completion(.failure(ImageServiceError.invalidURL))
                return
            }
            
            guard let (data, _) = try? await urlSession.data(from: url) else {
                completion(.failure(ImageServiceError.failedDownload))
                return
            }
            
            guard let image: UIImage = UIImage(data: data) else {
                completion(.failure(ImageServiceError.failedConvertUIImage))
                return
            }
            
            imageChache.setObject(image, forKey: urlString as NSString)
            completion(.success(image))
        }
    }
}
