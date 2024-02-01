//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellId               : String = "WeatherCell"
    private var dateLabel           : CustomCellLabel = CustomCellLabel()
    private var temperatureLabel    : CustomCellLabel = CustomCellLabel()
    private var weatherLabel        : CustomCellLabel = CustomCellLabel()
    private var dashLabel           : CustomCellLabel = CustomCellLabel()
    private var descriptionLabel    : CustomCellLabel = CustomCellLabel()
    private var weatherStackView    : UIStackView!
    private var verticalStackView   : UIStackView!
    private var contentsStackView   : UIStackView!
    private var weatherIcon         : UIImageView = UIImageView()
    private var defaultImage        : UIImage? = UIImage(systemName: "arrow.down.circle.dotted")
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        resetCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    
    // MARK: - SetupUI
    private func setUpLayout() {
        layoutWeatherStackView()
        layoutVerticalStackView()
        layoutContentStackView()
    }
    
    private func layoutWeatherStackView() {
        weatherStackView = UIStackView(arrangedSubviews: [
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
    }
    
    private func layoutVerticalStackView() {
        verticalStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
    }
    
    private func layoutContentStackView() {
        contentsStackView = UIStackView(arrangedSubviews: [
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
    
    private func resetCell() {
        weatherIcon.image = defaultImage
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
    
    // MARK: - UI Update Method
    func updateCellUI(with weatherForecastInfo: WeatherForecastInfo, tempUnit: TemperatureUnit, imageManager: ImageManagerProtocol) {
        weatherLabel.text = weatherForecastInfo.weather.main
        descriptionLabel.text = weatherForecastInfo.weather.description
        temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        dateLabel.text = date.formattedStringFromDate()
        
        let iconName: String = weatherForecastInfo.weather.icon
        imageManager.fetchImage(of: iconName) { [weak self] image in
            DispatchQueue.main.async {
                self?.weatherIcon.image = image
            }
        }
    }
    
}
