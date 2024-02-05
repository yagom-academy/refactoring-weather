//
//  DetailDateFormattable.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/4/24.
//

import Foundation

protocol DetailDateFormattable {
    func string(from date: Date) -> String
}
