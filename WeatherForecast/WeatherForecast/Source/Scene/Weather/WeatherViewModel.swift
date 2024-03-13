//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//

import Foundation
import UIKit

protocol WeatherViewModel {
    var weatherForecast: [WeatherForecastInfo] { get }
    var city: City { get }
    var tempUnit: TempUnit { get }
    
    var navigationBarItemTitle: String { get }
    
    func fetch()
    func changeTempUnit()
    func getCachedImage(urlString key: String) -> UIImage?
    func setCachedImage(_ image: UIImage, urlString key: String)
}

final class WeatherViewModelImp: WeatherViewModel {
    private(set) var weatherForecast: [WeatherForecastInfo] = []
    private(set) var city: City = City.mock
    private(set) var tempUnit: TempUnit = .metric
    
    private let weatherService: WeatherJSONService
    private let imageCache: NSCache<NSString, UIImage>
    
    lazy var navigationBarItemTitle: String = {
        switch tempUnit {
        case.imperial: return "화씨"
        case .metric: return "섭씨"
        }
    }()
    
    init(weatherService: WeatherJSONService) {
        self.weatherService = weatherService
        
        imageCache = NSCache()
    }
    
    func fetch() {
        weatherService.fetchWeather { [weak self] data in
            guard let self = self else { return }
            
            self.weatherForecast = data.weatherForecast
            self.city = data.city
        }
        
        navigationBarItemTitle = tempUnit.expression
    }
    
    func changeTempUnit() {
        switch tempUnit {
        case .metric:
            tempUnit = .imperial
        case .imperial:
            tempUnit = .metric
        }
        
        navigationBarItemTitle = tempUnit.expression
    }
    
    func getCachedImage(urlString key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    func setCachedImage(_ image: UIImage, 
                        urlString key: String) {
        imageCache.setObject(image,
                              forKey: key as NSString)
    }
}
