//
//  WeatherForecastModel.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/1/24.
//

import UIKit

final class WeatherForecastModel {
    private let decoder: CustomDecoder
    private var weatherJSON: WeatherJSON!
    private var dataFetcher: DataFetchable
    
    init(decoder: CustomDecoder, dataFetcher: DataFetchable) {
        self.decoder = decoder
        self.dataFetcher = dataFetcher
        self.weatherJSON = dataFetcher.fetchWeatherJSON()
    }
}

extension WeatherForecastModel {
    // DataFetcher 구조체로 기능 이전
//    private func fetchWeatherJSON() {
//        
//        // 이 부분에서 메서드가 너무 많은 일을 함
////        (SRP 위배) 및 의존성 생김(DIP 위배)
////        let assetConvertor = NSDataAssetConvertor()
////        let decoder = CustomDecoder()
//        guard let data = try? assetConvertor.data("weather"),
//              let response = try? decoder.decode(WeatherJSON.self, data: data)
//        else { return }
//        
//        weatherJSON = response
//    }
}


extension WeatherForecastModel {
    var city: City {
        return weatherJSON.city
    }
    
    var cityName: String {
        return weatherJSON.city.name
    }
    
    var weatherForecastCount: Int {
        return weatherJSON.weatherForecast.count
    }
    
    var weatherForecast: [WeatherForecastInfo] {
        return weatherJSON.weatherForecast
    }
}
