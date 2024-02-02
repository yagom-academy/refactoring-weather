//
//  WeatherRepositoryService.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

protocol WeatherRepositoryService {
  func load() async -> Result<WeatherJSON, Error>
}
