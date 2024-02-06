//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = String(describing: WeatherTableViewCell.self)
    private var imageService: NetworkService?
    
    // MARK: - UI
    private var weatherIcon: UIImageView = UIImageView()
    private var dateLabel: UILabel = UILabel()
    private var temperatureLabel: UILabel = UILabel()
    private var weatherLabel: UILabel = UILabel()
    private var descriptionLabel: UILabel = UILabel()
     
    // MARK: - Init
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
    
    // MARK: - Layout
    private func layViews() {
        makeLabel()
        
        let weatherStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherLabel,
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
    
    private func makeLabel() {
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, descriptionLabel]
        
        labels.forEach { label in
            label.makeLabel()
        }
    }
    
    private func reset() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
    
    func configureCell(weatherInfo: WeatherForecastInfo,
                       imageService: NetworkService) {
        Task {
            weatherIcon.image = try? await imageService.fetchImage(iconName: weatherInfo.weather.icon, urlSession: URLSession.shared)
        }
        
        dateLabel.text = weatherInfo.dtTxt
        temperatureLabel.text = "\(weatherInfo.main.temp)"
        weatherLabel.text = weatherInfo.weather.main
        descriptionLabel.text = weatherInfo.weather.description
    }
}
