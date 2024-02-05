//
//  DateFormatType.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/30/24.
//

import Foundation

enum DateFormatType {
    case full
    case none
    
    var format: String? {
        switch self {
        case .full:
            return "yyyy-MM-dd(EEEEE) a HH:mm"
        case .none:
            return .none
        }
    }
}

