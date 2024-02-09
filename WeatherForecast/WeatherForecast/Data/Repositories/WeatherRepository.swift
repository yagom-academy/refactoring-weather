//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/9/24.
//

import Foundation

protocol WeatherRepository {
    func fetchWeatherList(from url: URL) async throws -> CityWeather
}

final class DefaultWeatherRepository: WeatherRepository {
    private let localWeatherDataService: WeatherDataService
    private let remoteWeatherDataService: WeatherDataService
    private let jsonDecoder: JSONDecoder
    
    func fetchWeatherList(from url: URL) async throws -> CityWeather {
        let weatherDataService: WeatherDataService
        
        if url.isFileURL {
            weatherDataService = localWeatherDataService
        } else {
            weatherDataService = remoteWeatherDataService
        }
        
        let data = try await weatherDataService.fetchWeathers(from: url)
        let dto = try jsonDecoder.decode(CityWeatherDTO.self, from: data)
        
        return dto.toDomain()
    }
    
    init(localWeatherDataService: WeatherDataService, remoteWeatherDataService: WeatherDataService, jsonDecoder: JSONDecoder) {
        self.localWeatherDataService = localWeatherDataService
        self.remoteWeatherDataService = remoteWeatherDataService
        self.jsonDecoder = jsonDecoder
    }
    
    convenience init() {
        self.init(
            localWeatherDataService: LocalWeatherDataService(),
            remoteWeatherDataService: RemoteWeatherDataService(),
            jsonDecoder: JSONDecoderCreator.createSnakeCaseDecoder()
        )
    }
}
