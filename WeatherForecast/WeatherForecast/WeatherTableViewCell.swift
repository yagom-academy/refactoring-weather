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
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func configure(
        with weatherForecastInfo: WeatherForecastInfo,
        tempUnit: TempUnit,
        imageCache: NSCache<NSString, UIImage>
    ) {
        setupWeatherLabel(with: weatherForecastInfo.weather.main)
        setupDescriptionlabel(with: weatherForecastInfo.weather.description)
        setupTemperatureLabel(with: "\(weatherForecastInfo.main.temp)\(tempUnit.expression)")
        setupDateLabel(with: weatherForecastInfo.dt)
        setupWeatherIcon(with: weatherForecastInfo.weather.icon, imageCache: imageCache)
    }
    
    private func setupWeatherLabel(with text: String) {
        weatherLabel.text = text
    }
    
    private func setupDescriptionlabel(with text: String) {
        descriptionLabel.text = text
    }
    
    private func setupTemperatureLabel(with text: String) {
        temperatureLabel.text = text
    }
    
    private func setupDateLabel(with timeInterval: TimeInterval) {
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func setupWeatherIcon(with iconName: String, imageCache: NSCache<NSString, UIImage>) {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            weatherIcon.image = image
            return
        }
        
        fetchIconImage(urlString: urlString, imageCache: imageCache)
    }
    
    private func fetchIconImage(urlString: String, imageCache: NSCache<NSString, UIImage>) {
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            imageCache.setObject(image, forKey: urlString as NSString)
            weatherIcon.image = image
        }
    }
    
    private func commonInit() {
        weatherIcon = UIImageView()
        dateLabel = UILabel()
        temperatureLabel = UILabel()
        weatherLabel = UILabel()
        descriptionLabel = UILabel()

        setupLabels()
       
        let weatherStackView = initWeatherStackView()
        let verticalStackView = initVerticalStackView(weatherStackView)
        let contentsStackView = initContentsStackView(verticalStackView)
       
        setupSubviews(contentsStackView)
        setupLayouts(contentsStackView)
    }
    
    private func setupLabels() {
        [dateLabel, temperatureLabel, weatherLabel, descriptionLabel]
            .forEach { label in
                label.textColor = .black
                label.font = .preferredFont(forTextStyle: .body)
                label.numberOfLines = 1
            }
    }
    
    private func initWeatherStackView() -> UIStackView {
        let weatherStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherLabel,
            descriptionLabel
        ])
        
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 8
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        
        return weatherStackView
    }
    
    private func initVerticalStackView(_ weatherStackView: UIStackView) -> UIStackView {
        let verticalStackView: UIStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        
        return verticalStackView
    }
    
    private func initContentsStackView(_ verticalStackView: UIStackView) -> UIStackView {
        let contentsStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherIcon,
            verticalStackView
        ])
        
        contentsStackView.axis = .horizontal
        contentsStackView.spacing = 16
        contentsStackView.alignment = .center
        contentsStackView.distribution = .fill
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentsStackView
    }
    
    private func setupSubviews(_ contentsStackView: UIStackView) {
        contentView.addSubview(contentsStackView)
    }
    
    private func setupLayouts(_ contentsStackView: UIStackView) {
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
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
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
}
