//
//  ImageServiceError.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl     // url 에러
    case networkFail    // 응답상태코드 에러
    case invalidData    // 유효하지 않은 데이터
}
