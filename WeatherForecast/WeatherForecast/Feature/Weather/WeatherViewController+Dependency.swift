//
//  WeatherViewController+Dependency.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/17/24.
//

import Foundation

protocol WeatherViewControllerDependencyProtocol {
    var imageLodaer: ImageLoader { get }
}

struct WeatherViewControllerDependency: WeatherViewControllerDependencyProtocol {
    init(imageLoader: ImageLoader) {
        self.imageLodaer = imageLoader
    }
    
    var imageLodaer: ImageLoader
}

// 이런 방식으로 Test용 mockup 모듈을 연결할 수 있음! 
// extension WeatherViewControllerDependency {
//     static func mocked() -> WeatherViewControllerDependency {
//         return WeatherViewControllerDependency(imageLoader: MockedImageLoader())
//     }
// }
