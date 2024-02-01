//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

enum JsonError: Error {
    case emptyData      // 데이터 미존재
    case failDecode     // 디코드 실패
}
