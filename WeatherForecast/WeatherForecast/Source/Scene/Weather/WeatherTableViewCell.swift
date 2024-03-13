//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    static let identifier = String(describing: WeatherTableViewCell.self)
    
    let weatherIcon: UIImageView = UIImageView()
    let dateLabel: UILabel = UILabel()
    let temperatureLabel: UILabel = UILabel()
    let weatherLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    let dashLabel: UILabel = UILabel()
     
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
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
        let labels: [UILabel] = [dateLabel, 
                                 temperatureLabel,
                                 weatherLabel,
                                 dashLabel,
                                 descriptionLabel]
        
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
        
        let weatherStackView: UIStackView = UIStackView(arrangedSubviews: [weatherLabel,
                                                                           dashLabel,
                                                                           descriptionLabel])
        
        descriptionLabel.setContentHuggingPriority(.defaultLow,
                                                   for: .horizontal)
        
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 8
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        
        let verticalStackView: UIStackView = UIStackView(arrangedSubviews: [dateLabel,
                                                                            temperatureLabel,
                                                                            weatherStackView])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        
        let contentsStackView: UIStackView = UIStackView(arrangedSubviews: [weatherIcon,
                                                                            verticalStackView])
               
        contentsStackView.axis = .horizontal
        contentsStackView.spacing = 16
        contentsStackView.alignment = .center
        contentsStackView.distribution = .fill
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentsStackView)
                
        NSLayoutConstraint.activate([contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                                     contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                                     contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                                     contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                                     weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
                                     weatherIcon.widthAnchor.constraint(equalToConstant: 100)])
    }
    
    private func reset() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
    
    func configure(weatherForecastInfo: WeatherForecastInfo, tempUnit: TempUnit, imageService: WeatherImageService) {
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        let iconName: String = weatherForecastInfo.weather.icon
        
        weatherLabel.text = weatherForecastInfo.weather.main
        descriptionLabel.text = weatherForecastInfo.weather.description
        temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.symbol)"
        dateLabel.text = DateFormatter.convertToKorean(by: date)
        
        imageService.fetchImage(iconName: iconName) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                weatherIcon.image = image
            }
        }
    }
}
