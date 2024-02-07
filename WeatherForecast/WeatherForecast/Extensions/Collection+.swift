//
//  Collection+.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import Foundation


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
