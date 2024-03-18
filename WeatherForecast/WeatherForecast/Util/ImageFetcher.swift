//
//  ImageFetcher.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit
import Combine

enum ImageFetchError: Error {
    case createUIImageFailed
}

protocol ImageFetcher {
    func loadImage(url: URL) -> AnyPublisher<UIImage, Error>
}

struct ImageFetcherImpl: ImageFetcher {
    func loadImage(url: URL) -> AnyPublisher<UIImage, Error> {
        return Future<UIImage, Error> { promise in
            if let cachedImage: UIImage = ImageCache.shared.get(forKey: url.absoluteString as NSString) {
                promise(.success(cachedImage))
                return
            }
            
            Task {
                do {
                    let responseData: (Data, URLResponse) = try await URLSession.shared.data(from: url)
                    guard let uiImage: UIImage = UIImage(data: responseData.0)
                    else {
                        throw ImageFetchError.createUIImageFailed
                    }
                    
                    ImageCache.shared.set(uiImage, forKey: url.absoluteString as NSString)
                    promise(.success(uiImage))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
