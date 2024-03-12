//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by Park Sungmin on 3/12/24.
//

import Foundation

extension Date {
    func toFormattedString(_ dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm") -> String? {
        let dateFormatter: DateFormatter = {
            let formatter: DateFormatter = DateFormatter()
            formatter.locale = .init(identifier: "ko_KR")
            formatter.dateFormat = dateFormat
            return formatter
        }()
        
        return dateFormatter.string(from: self) 
    }
}
