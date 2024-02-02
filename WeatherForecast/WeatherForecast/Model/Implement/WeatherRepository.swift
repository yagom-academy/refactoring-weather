//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

struct WeatherRepository: WeatherRepositoryService {
  private let dataAssetProvider: DataAssetProviderService
  
  init(dataAssetProvider: DataAssetProviderService) {
    self.dataAssetProvider = dataAssetProvider
  }
}

extension WeatherRepository {
  func load() async -> Result<WeatherJSON, Error> {
    var result: Result<WeatherJSON, Error>
    
    let dataResult = dataAssetProvider
      .data(
        WeatherJSON.self,
        name: "weather"
      )
    
    switch dataResult {
    case .success(let weather):
      result = .success(weather)
    case .failure(let error):
      result = .failure(error)
    }
    
    return result
  }
}
