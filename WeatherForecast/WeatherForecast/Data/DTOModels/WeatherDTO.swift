//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

final class WeatherDTO: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
