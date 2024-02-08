//
//  MainInfo.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class MainInfo: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}
