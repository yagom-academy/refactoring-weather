//
//  KeyValueLabel.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

import UIKit

final class KeyValueLabel: UILabel {
  init(key: String) {
    super.init(frame: .zero)
    text = "\(key) : "
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

extension KeyValueLabel {
  public func update(value: String) {
    guard let currentText = text else { return }
    text = currentText + value
  }
}
