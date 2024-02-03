//
//  WeatherConditionView.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

import UIKit

final class WeatherConditionView: UIView {
  private let contentsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WeatherConditionView {
  private func setupView() {
    addSubview(contentsStackView)
    NSLayoutConstraint.activate([
      contentsStackView.topAnchor.constraint(equalTo: topAnchor),
      contentsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      contentsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}

extension WeatherConditionView {
  public func update(_ conditions: [WeatherCondition]) {
    let keyValueLabels = conditions.map {
      let keyValueLabel = KeyValueLabel(key: $0.title)
      keyValueLabel.update(value: $0.value)
      return keyValueLabel
    }
    
    keyValueLabels.forEach { [weak self] in
      self?.contentsStackView.addArrangedSubview($0)
    }
  }
}

struct WeatherCondition {
  let title: String
  let value: String
}

