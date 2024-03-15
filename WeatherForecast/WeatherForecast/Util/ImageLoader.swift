//
//  ImageFetcher.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/13/24.
//

import UIKit

final class ImageLoader {
    static func loadUIImage(from urlString: String) async -> UIImage? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) 
        else {
            return nil
        }
        return image
    }
}
