//
//  WeatherDataService.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/9/24.
//

import Foundation

protocol WeatherDataService {
    func fetchWeathers(from url: URL) async throws -> Data
}

final class LocalWeatherDataService: WeatherDataService {
    func fetchWeathers(from url: URL) async throws -> Data {
        return try Data(contentsOf: url)
    }
}

final class RemoteWeatherDataService: WeatherDataService {
    func fetchWeathers(from url: URL) async throws -> Data {
        let (date, _) = try await URLSession.shared.data(from: url)
        return date
    }
}
