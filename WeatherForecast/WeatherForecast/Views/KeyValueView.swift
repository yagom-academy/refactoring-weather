//
//  KeyValueView.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

import UIKit

final class KeyValueView: UIView {
  private let keyValueLabel: KeyValueLabel
  init(key: String) {
    keyValueLabel = .init(key: key)
    keyValueLabel.translatesAutoresizingMaskIntoConstraints = false
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension KeyValueView {
  private func setupView() {
    addSubview(keyValueLabel)
    NSLayoutConstraint.activate([
      keyValueLabel.topAnchor.constraint(equalTo: topAnchor),
      keyValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      keyValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      keyValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}

extension KeyValueView {
  public func update(value: String) {
    keyValueLabel.update(value: value)
  }
}
