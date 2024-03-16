//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

struct WeatherCellInfo {
  let dt: TimeInterval
  let main: MainInfo
  let weather: Weather
  let tempExpression: String
}

final class WeatherTableViewCell: UITableViewCell, DateFormattable {
  static let identifier: String = "WeatherTableViewCell"
  
  private let weatherIcon: UIImageView = .init()
  private let dateLabel: UILabel = .init()
  private let temperatureLabel: UILabel = .init()
  private let weatherLabel: UILabel = .init()
  private let descriptionLabel: UILabel = .init()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setLayout()
    reset()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    reset()
  }
  
  private func setLayout() {
    let dashLabel: UILabel = .init()
    
    [
      dateLabel, 
      temperatureLabel,
      weatherLabel,
      dashLabel,
      descriptionLabel
    ]
    .forEach { label in
      label.textColor = .black
      label.font = .preferredFont(forTextStyle: .body)
      label.numberOfLines = 1
    }
    
    let weatherStackView: UIStackView = .init(
        arrangedSubviews: [
          weatherLabel,
          dashLabel,
          descriptionLabel
        ],
        alignment: .center,
        axis: .horizontal,
        spacing: 8
    )
    descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    let verticalStackView: UIStackView = .init(
        arrangedSubviews: [
          dateLabel,
          temperatureLabel,
          weatherStackView
        ],
        alignment: .leading,
        axis: .vertical,
        spacing: 8
    )
    
    let contentsStackView: UIStackView = .init(
        arrangedSubviews: [
          weatherIcon,
          verticalStackView
        ],
        alignment: .center,
        axis: .horizontal,
        spacing: 16
    )
    contentsStackView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(contentsStackView)
    
    NSLayoutConstraint.activate([
      contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
      weatherIcon.widthAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  private func reset() {
    weatherIcon.image = .init(systemName: "arrow.down.circle.dotted")
    dateLabel.text = "0000-00-00 00:00:00"
    temperatureLabel.text = "00℃"
    weatherLabel.text = "~~~"
    descriptionLabel.text = "~~~~~"
  }
  
  func configure(weatherCellInfo info: WeatherCellInfo) {
    weatherLabel.text = info.weather.main
    descriptionLabel.text = info.weather.description
    temperatureLabel.text = "\(info.main.temperature)\(info.tempExpression)"
    dateLabel.text = dateFormat(from: info.dt, with: .KoreanLongForm)
  }
  
  func set(image: UIImage) {
    weatherIcon.image = image
  }
}
