//
//  Date+.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatterKR = DateFormatterKR(dateFormat: "yyyy-MM-dd(EEEEE) a HH:mm")
        return dateFormatterKR.string(from: self)
    }
}
