//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    private var weatherIcon: UIImageView = UIImageView()
    private var dateLabel: UILabel = UILabel()
    private var temperatureLabel: UILabel =  UILabel()
    private var weatherLabel: UILabel = UILabel()
    private var descriptionLabel: UILabel = UILabel()
    private var contentsStackView: UIStackView = UIStackView()
    private var verticalStackView: UIStackView = UIStackView()
    private var weatherStackView: UIStackView = UIStackView()
    private let dateFormatter: DateFormatter = DateFormatterCreator.createKoreanDateFormatter()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
        resetUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        layoutUI()
        resetUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    func configure(image: UIImage) {
        weatherIcon.image = image
    }
    
    func configure(with weatherForecastInfo: Weather, using tempUnit: TemperatureUnit) {
        configureLables(with: weatherForecastInfo, using: tempUnit)
    }
    
    private func configureLables(with weather: Weather, using tempUnit: TemperatureUnit) {
        weatherLabel.text = weather.condition.main
        descriptionLabel.text = weather.condition.description
        temperatureLabel.text = "\(tempUnit.strategy.convertTemperature(weather.temperature.current))"
        
        let date: Date = weather.date
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func resetUI() {
        resetImage()
        resetLabels()
    }
    
    private func resetImage() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
    }
    
    private func resetLabels() {
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
}

// MARK: - UI
extension WeatherTableViewCell {
    private func configureUI() {
        contentView.addSubview(contentsStackView)
        configureContentsStackView()
        configureVerticalStackView()
        configureWeatherStackView()
        configureLables()
    }
    
    private func configureContentsStackView() {
        contentsStackView.addArrangedSubview(weatherIcon)
        contentsStackView.addArrangedSubview(verticalStackView)
        
        contentsStackView.axis = .horizontal
        contentsStackView.spacing = 16
        contentsStackView.alignment = .center
        contentsStackView.distribution = .fill
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureVerticalStackView() {
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(temperatureLabel)
        verticalStackView.addArrangedSubview(weatherStackView)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
    }
    
    private func configureWeatherStackView() {
        weatherStackView.addArrangedSubview(weatherLabel)
        weatherStackView.addArrangedSubview(descriptionLabel)
    
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 8
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
    }
    
    private func configureLables() {
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, descriptionLabel]
        
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
        
        descriptionLabel.setContentHuggingPriority(.defaultLow,
                                                   for: .horizontal)
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
