//
//  Extensions.swift
//  WeatherForecast
//
//  Created by 윤형석 on 1/30/24.
//

import Foundation
import UIKit

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toString(timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

extension Data {
    func toUIImage() -> UIImage? {
        return UIImage(data: self)
    }
}

extension TimeInterval {
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
