//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

import UIKit

final class WeatherDetailView: UIView {
  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  private let weatherSituationView = WeatherSituationView()
  private let weatherConditionView = WeatherConditionView()
  private let spacingView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.setContentHuggingPriority(
      .defaultLow,
      for: .vertical
    )
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WeatherDetailView {
  private func setupView() {
    addSubview(mainStackView)
    mainStackView.addArrangedSubview(weatherSituationView)
    mainStackView.addArrangedSubview(weatherConditionView)
    mainStackView.addArrangedSubview(spacingView)
    
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -16)
    ])
  }
}

extension WeatherDetailView {
  public func update(_ weatherDetailModel: WeatherDetailModel) {
    weatherSituationView.update(weatherDetailModel.weatherSituation)
    weatherConditionView.update(weatherDetailModel.weatherConditions)
  }
}

