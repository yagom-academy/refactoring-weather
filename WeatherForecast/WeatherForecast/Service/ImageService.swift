//
//  NetwortService.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/31/24.
//

import UIKit

protocol ImageFetchable {
    func fetchIconImage(urlString: String) async -> UIImage?
}

class ImageService: ImageFetchable {
    
    func fetchIconImage(urlString: String) async -> UIImage? {        
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
