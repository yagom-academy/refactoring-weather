//
//  WeatherInformationLabel.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/17/24.
//

import UIKit

class WeatherInformationLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    textColor = .black
    backgroundColor = .clear
    numberOfLines = 1
    textAlignment = .center
    font = .preferredFont(forTextStyle: .body)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
