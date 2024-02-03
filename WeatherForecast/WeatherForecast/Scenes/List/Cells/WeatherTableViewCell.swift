//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


final class WeatherTableViewCell: UITableViewCell {
    private let weatherIcon: UIImageView = UIImageView()
    private let dateLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let weatherLabel: UILabel = UILabel()
    private let dashLabel: UILabel = UILabel()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        setConstraints()
        resetUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetUI()
    }
}

extension WeatherTableViewCell {
    private func makeUI() {
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, dashLabel, descriptionLabel]
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
        
        let weatherArrangedSubviews = [
            weatherLabel,
            dashLabel,
            descriptionLabel
        ]
        weatherArrangedSubviews.forEach { weatherStackView.addArrangedSubview($0) }
        
        let verticalArrangedSubviews = [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ]
        verticalArrangedSubviews.forEach { verticalStackView.addArrangedSubview($0) }
        
        let contentArrangedSubviews = [
            weatherIcon,
            verticalStackView
        ]
        contentArrangedSubviews.forEach { contentsStackView.addArrangedSubview($0) }
        
        contentView.addSubview(contentsStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func resetUI() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
}


extension WeatherTableViewCell {
    func configure(with info: WeatherForecast, tempUnit: TempUnit) {
        weatherLabel.text = info.title
        descriptionLabel.text = info.description
        temperatureLabel.text = "\(info.temp)"
        dateLabel.text = "\(info.updatedDate)"
        weatherIcon.loadImage(with: info.iconUrl.value)
    }
}
