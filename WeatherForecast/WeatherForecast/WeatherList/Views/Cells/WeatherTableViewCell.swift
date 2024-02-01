//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    //MARK: - Properties
    var imageService: ImageServiceable?
    
    //MARK: - UI
    private var weatherIcon: UIImageView!
    private var dateLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var weatherLabel: UILabel!
    private var descriptionLabel: UILabel!
     
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layViews()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    //MARK: - Layout
    private func layViews() {
        weatherIcon = UIImageView()
        dateLabel = UILabel()
        temperatureLabel = UILabel()
        weatherLabel = UILabel()
        let dashLabel: UILabel = UILabel()
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
    
    //MARK: - Methods
    private func reset() {
        imageService = nil
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
    
    func configure(weatherInfo: WeatherInfoCoordinator,
                   iconName: String,
                   index: Int,
                   imageService: ImageServiceable) {
        guard let weatherForecastInfo = weatherInfo.getWeatherForecastInfo(at: index),
              let weatherForecastTemp = weatherInfo.getTemp(at: index) else {
            return
        }
        self.imageService = imageService
        
        weatherLabel.text      = weatherForecastInfo.weatherMain
        descriptionLabel.text  = weatherForecastInfo.description
        temperatureLabel.text  = weatherForecastTemp
        dateLabel.text         = weatherForecastInfo.date
        
        updateWeatherIcon(iconName: iconName)
    }
    
    private func updateWeatherIcon(iconName: String) {
        imageService?.getIcon(iconName: iconName, urlSession: URLSession.shared) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.weatherIcon.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
