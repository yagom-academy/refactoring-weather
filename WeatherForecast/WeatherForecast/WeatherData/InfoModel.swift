//
//  InfoModel.swift
//  WeatherForecast
//
//  Created by 김정원 on 2/7/24.
//

import Foundation
import UIKit

struct CityDetailInfo {
    
    var city: City
    
    var sunrise: String {
        return DateFormatter.koreanTimeFormatter.string(from: Date(timeIntervalSince1970: city.sunrise))
    }

    var sunset: String {
        return DateFormatter.koreanTimeFormatter.string(from: Date(timeIntervalSince1970: city.sunset))
    }
    
    init(city: City) {
        self.city = city
    }
}
 
