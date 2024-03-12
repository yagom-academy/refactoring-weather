//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  var weatherIcon: UIImageView!
  var dateLabel: UILabel!
  var temperatureLabel: UILabel!
  var weatherLabel: UILabel!
  var descriptionLabel: UILabel!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layViews()
    reset()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    reset()
  }
  
  private func layViews() {
    weatherIcon = .init()
    dateLabel = .init()
    temperatureLabel = .init()
    weatherLabel = .init()
    let dashLabel: UILabel = .init()
    descriptionLabel = .init()
    
    let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, dashLabel, descriptionLabel]
    
    labels.forEach { label in
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
}
