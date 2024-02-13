//
//  City.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/8/24.
//

import Foundation

final class CityDTO: Decodable {
    let id: Int
    let name: String
    let coord: CoordDTO
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
    
    func toDomain() -> City {
        return City(
            name: self.name,
            sunrise: Date(timeIntervalSince1970: self.sunrise),
            sunset: Date(timeIntervalSince1970: self.sunset)
        )
    }
}
