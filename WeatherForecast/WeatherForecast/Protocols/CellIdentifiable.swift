//
//  CellIdentifiable.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/17/24.
//

import Foundation

protocol CellIdentifiable {
  static var identifier: String { get }
}

extension CellIdentifiable {
  static var identifier: String {
    .init(describing: Self.self)
  }
}
