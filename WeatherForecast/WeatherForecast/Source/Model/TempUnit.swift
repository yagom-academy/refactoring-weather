//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/12.
//


// MARK: - Temperature Unit
enum TempUnit: String {
    case celsius, fahrenheit
    
    var symbol: String {
        switch self {
        case .celsius: 
            return "℃"
        case .fahrenheit: 
            return "℉"
        }
    }
    
    var description: String {
        switch self {
        case .celsius: 
            return "섭씨"
        case .fahrenheit: 
            return "화씨"
        }
    }
}
