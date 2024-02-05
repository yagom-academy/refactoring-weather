//
//  Collection+.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
