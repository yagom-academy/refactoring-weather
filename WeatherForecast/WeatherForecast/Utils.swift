//
//  Utils.swift
//  WeatherForecast
//
//  Created by qussk on 3/21/24.
//

import UIKit


class Utils {
    static func dateSetUp(_ format: String?) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        let dateFormat = DateFormat(dataFormater: format, dateFormatStyle: .none)
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: dateFormat.locale)
        formatter.dateFormat = dateFormat.dataFormater

        guard format != nil else {
            formatter.dateFormat = .none
            return formatter
        }

        return formatter
    }

}

