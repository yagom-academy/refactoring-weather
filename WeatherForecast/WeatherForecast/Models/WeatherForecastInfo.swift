//
//  WeatherForecastInfo.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
}
