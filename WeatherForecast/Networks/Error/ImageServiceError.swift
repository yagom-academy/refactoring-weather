//
//  ImageServiceError.swift
//  WeatherForecast
//
//  Created by 김창규 on 2/1/24.
//

import Foundation

enum ImageServiceError: Error {
    case invalidURL
    case failedDownload
    case failedConvertUIImage
}
