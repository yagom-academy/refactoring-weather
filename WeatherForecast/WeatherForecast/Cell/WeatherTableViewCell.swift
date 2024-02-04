//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    var weatherIcon: UIImageView!
    var dashLabel: UILabel!
    var dateLabel: UILabel!
    var temperatureLabel: UILabel!
    var weatherLabel: UILabel!
    var descriptionLabel: UILabel!
    var tempUnit: TempUnit = .metric
    let imageCacheManager: ImageCacheManager = ImageCacheManager() // TODO: 최초 앱 실행시에 주입해주는 방식으로 바꾸기
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        resetToInitial()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetToInitial()
    }
    
    func configure(weatherForecastInfo: WeatherForecastInfo) {
        weatherLabel.text = weatherForecastInfo.weather.main
        descriptionLabel.text = weatherForecastInfo.weather.description
        temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        dateLabel.text = dateFormatter.string(from: date)
        loadImage(from: weatherForecastInfo.weather.icon)
    }
    
    private func loadImage(from iconName: String) {
        Task {
            let image = await imageCacheManager.loadImage(from: iconName)
            DispatchQueue.main.async {
                self.weatherIcon.image = image
            }
        }
    }
    
    private func resetToInitial() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
}

// MARK: - Layout
extension WeatherTableViewCell {
    private func setupLayout() {
        weatherIcon = UIImageView()
        dateLabel = UILabel()
        temperatureLabel = UILabel()
        weatherLabel = UILabel()
        dashLabel = UILabel()
        descriptionLabel = UILabel()
        
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, dashLabel, descriptionLabel]
        
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
        
        let weatherStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherLabel,
            dashLabel,
            descriptionLabel
        ])
        
        descriptionLabel.setContentHuggingPriority(.defaultLow,
                                                   for: .horizontal)
        
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 8
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        
        
        let verticalStackView: UIStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        
        let contentsStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherIcon,
            verticalStackView
        ])
               
        contentsStackView.axis = .horizontal
        contentsStackView.spacing = 16
        contentsStackView.alignment = .center
        contentsStackView.distribution = .fill
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
}
