//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by 김정원 on 2/4/24.
//
import UIKit
final class TransforJSON {
    static let shared = TransforJSON()
    private init() {}
    
    func fetchWeatherJSON() -> WeatherJSON?{
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return info
    }

}
final class ImageCacheManager {
    static let shared = ImageCacheManager() // 싱글턴 인스턴스
    private var imageCache: NSCache<NSString, UIImage> = NSCache()

    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
        log("Image cached for key: \(key)")
    }

    func getImage(forKey key: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: key as NSString) {
            log("Returning cached image for key: \(key)")
            return cachedImage
        }
        log("No cached image : \(key)")
        return nil
    }
    
    private func log(_ message: String) {
        print(message)
    }
}
