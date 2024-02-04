//
//  WeatherListDetailViewModel.swift
//  WeatherForecast
//
//  Created by 윤형석 on 2/3/24.
//

import Foundation

final class WeatherListDetailViewModel {
    private(set) var tempUnit: TempUnit = .metric
    private(set) var cityInfo: City?
    private(set) var weatherForecastInfo: WeatherForecastInfo?
    
    let dataRequester: DataRequestable
    
    var iconName: String? {
        return weatherForecastInfo?.weather.icon
    }
    
    init(dataRequester: DataRequestable) {
        self.dataRequester = dataRequester
    }
}

// MARK: - Return Funcs..

extension WeatherListDetailViewModel {
    
    func urlStringForIconRequest(iconName: String) -> String {
        return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
    
    func weatherIconImageDataAfterRequest(urlString: String) async -> Data? {
        do {
            let data = try await dataRequester.request(urlString: urlString)
            return data
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Set Funcs..

extension WeatherListDetailViewModel {
    
    func setWeatherForecastInfo(_ value: WeatherForecastInfo?) {
        weatherForecastInfo = value
    }
    
    func setCityInfo(_ value: City?) {
        cityInfo = value
    }
    
    func setTempUnit(_ value: TempUnit) {
        tempUnit = value
    }
}
