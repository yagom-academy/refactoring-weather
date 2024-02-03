//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by ChangMin on 2/3/24.
//

import Foundation

enum NetworkError: Error {
    case invalidData
    case decodingError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .decodingError:
            return "디코딩 에러 발생했습니다."
        }
    }
}
