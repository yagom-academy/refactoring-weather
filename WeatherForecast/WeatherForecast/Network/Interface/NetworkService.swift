//
//  ImageService.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import UIKit

protocol NetworkService {
    func fetchImage(iconName: String, 
                    urlSession: URLSession) async throws -> UIImage
}
