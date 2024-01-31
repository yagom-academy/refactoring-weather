//
//  City.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import Foundation

// MARK: - Ci
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
    
    var sunriseString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter.string(from: Date(timeIntervalSince1970: sunrise))
    }
    
    var sunsetString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter.string(from: Date(timeIntervalSince1970: sunset))
    }
}
