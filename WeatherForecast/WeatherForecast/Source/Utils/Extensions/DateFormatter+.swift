//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//

import Foundation

extension DateFormatter {
    static func convertToKorean(by date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        
        let time = formatter.string(from: date)
        
        return time
    }
    
    static func convertToCityTime(by date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        
        let time = formatter.string(from: date)
        
        return time
    }
}
