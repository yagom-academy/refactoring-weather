//
//  DetailDateFormattable.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/4/24.
//

import Foundation

protocol DateFormattable {
    func string(from date: Date) -> String
}
