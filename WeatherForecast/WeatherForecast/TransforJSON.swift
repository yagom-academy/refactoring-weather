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
    
    func fetchWeatherJSON(weatherInfo: WeatherJSON?) -> WeatherJSON?{
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
    func fetchWeatherIconImage(iconName: String) async -> UIImage? {
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        let cacheKey = NSString(string: urlString)

        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            return cachedImage
        }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            ImageCacheManager.shared.cacheImage(image, forKey: urlString)
            
            return image
        } catch {
            print("Error fetching weather icon: \(error)")
            return nil
        }
    }

}
class ImageCacheManager {
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
