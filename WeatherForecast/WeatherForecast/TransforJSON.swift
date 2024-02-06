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
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error fetching weather icon: \(error)")
            return nil
        }
    }
}
