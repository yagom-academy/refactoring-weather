//
//  WeatherDetailInfoCoordinator.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/31/24.
//

import Foundation

protocol WeatherDetailInfoCoordinator {
    var date: String { get }
    
    var sunrise: String { get }
    var sunset: String { get }
    
    var weatherMain: String { get }
    var description: String { get }
    
    var temp: String { get }
    var tempMax: String { get }
    var tempMin: String { get }
    
    var feelsLike: String { get }
    var pop: String { get }
    
    var humidity: String { get }
    
    var iconName: String { get }
}
