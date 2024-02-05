//
//  WeatherSituationView.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

import UIKit

final class WeatherSituationView: UIView {
  private let contentsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  private let iconImageView: UIImageView = UIImageView()
  private let weatherGroupLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    return label
  }()
  private let weatherDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WeatherSituationView {
  private func setupView() {
    addSubview(contentsStackView)
    contentsStackView.addArrangedSubview(iconImageView)
    contentsStackView.addArrangedSubview(weatherGroupLabel)
    contentsStackView.addArrangedSubview(weatherDescriptionLabel)
    NSLayoutConstraint.activate([
      contentsStackView.topAnchor.constraint(equalTo: topAnchor),
      contentsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      contentsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
      iconImageView.widthAnchor.constraint(
        equalTo: widthAnchor,
        multiplier: 0.3
      )
    ])
  }
}

extension WeatherSituationView {
  public func update(_ weatherSituation: WeatherSituation) {
    weatherGroupLabel.text = weatherSituation.weatherGroup
    weatherDescriptionLabel.text = weatherSituation.weatherDescription
    Task {
      let image = await ImageProvider.shared.image(url: weatherSituation.imageURL)
      iconImageView.image = image
    }
  }
}
