//
//  WeatherListUseCase.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/3/24.
//

import Foundation

protocol WeatherListUseCase {
    func fetchWeatherList(url: URL?) -> CityWeather?
    func fetchWeatherImage(url: String) async -> ImageCache?
}

final class DefaultWeatherListUseCase: WeatherListUseCase {
    private var imageCacheService: ImageChacheService
    
    init(imageCacheService: ImageChacheService) {
        self.imageCacheService = imageCacheService
    }
    
    convenience init() {
        self.init(imageCacheService: DefaultImageChacheService.shared)
    }
    
    func fetchWeatherList(url: URL?) -> CityWeather? {
        let jsonDecoder: JSONDecoder = JSONDecoderCreator.createSnakeCaseDecoder()

        guard let url: URL = url else { return nil }
        let info: CityWeather
        
        do {
            let data: Data = try Data(contentsOf: url)
            info = try jsonDecoder.decode(CityWeather.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return info
    }
    
    func fetchWeatherImage(url: String) async -> ImageCache? {
        await imageCacheService.fetchImage(urlString: url)
    }
}
