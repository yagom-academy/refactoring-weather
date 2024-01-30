//
//  IconServiceable.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//
import UIKit

protocol ImageServiceable {
    func getIcon(iconName: String, completion: @escaping (UIImage) -> ())
}
