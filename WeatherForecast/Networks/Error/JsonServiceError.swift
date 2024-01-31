//
//  JsonServiceError.swift
//  WeatherForecast
//
//  Created by 김창규 on 2/1/24.
//

import Foundation

enum JsonServiceError: Error {
    case jsonNotExist
    case decodeError
}
