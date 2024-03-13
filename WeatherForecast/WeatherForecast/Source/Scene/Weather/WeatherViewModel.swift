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
    func fetchImage(iconName: String, completion: @escaping (UIImage) -> ())
}

final class WeatherViewModelImp: WeatherViewModel {
    private(set) var weatherForecast: [WeatherForecastInfo] = []
    private(set) var city: City = City.mock
    private(set) var tempUnit: TempUnit
    private let weatherService: WeatherJSONService
    private let imageService: WeatherImageService
    private let imageCache: NSCache<NSString, UIImage>
    
    var navigationBarItemTitle: String {
        return tempUnit.description
    }
    
    init(weatherService: WeatherJSONService,
         imageService: WeatherImageService,
         tempUnit: TempUnit) {
        self.weatherService = weatherService
        self.imageService = imageService
        self.tempUnit = tempUnit
        imageCache = NSCache()
    }
    
    func fetch() {
        weatherService.fetchWeather { [weak self] data in
            guard let self = self else { return }
            
            self.weatherForecast = data.weatherForecast
            self.city = data.city
        }
    }
    
    func changeTempUnit() {
        tempUnit.toggle()
    }
    
    func fetchImage(iconName: String, completion: @escaping (UIImage) -> ()) {
        imageService.fetchImage(iconName: iconName) { image in
            completion(image)
        }
    }
}
