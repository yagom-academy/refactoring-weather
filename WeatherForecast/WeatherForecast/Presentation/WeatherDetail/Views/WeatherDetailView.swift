//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by JunHeeJo on 2/7/24.
//

import UIKit

final class WeatherDetailView: UIView {
    let mainStackView: UIStackView = UIStackView()
    let iconImageView: UIImageView = UIImageView()
    let weatherGroupLabel: UILabel = UILabel()
    let weatherDescriptionLabel: UILabel = UILabel()
    let temperatureLabel: UILabel = UILabel()
    let feelsLikeLabel: UILabel = UILabel()
    let maximumTemperatureLable: UILabel = UILabel()
    let minimumTemperatureLable: UILabel = UILabel()
    let popLabel: UILabel = UILabel()
    let humidityLabel: UILabel = UILabel()
    let sunriseTimeLabel: UILabel = UILabel()
    let sunsetTimeLabel: UILabel = UILabel()
    let spacingView: UIView = UIView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        layoutUI()
    }
}

// MARK: Configure UI
extension WeatherDetailView {
    private func configureUI() {
        backgroundColor = .white
        configureMainStackView()
        configureLabels()
        configureSpacingView()
    }
    
    private func configureMainStackView() {
        addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLabels() {
        addLabels()
        
        mainStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        configureLargeTitleFont()
    }
    
    private func addLabels() {
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(weatherGroupLabel)
        mainStackView.addArrangedSubview(weatherDescriptionLabel)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(feelsLikeLabel)
        mainStackView.addArrangedSubview(maximumTemperatureLable)
        mainStackView.addArrangedSubview(minimumTemperatureLable)
        mainStackView.addArrangedSubview(popLabel)
        mainStackView.addArrangedSubview(humidityLabel)
        mainStackView.addArrangedSubview(sunriseTimeLabel)
        mainStackView.addArrangedSubview(sunsetTimeLabel)
    }
    
    private func configureLargeTitleFont() {
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private func configureSpacingView() {
        mainStackView.addArrangedSubview(spacingView)
        
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}


// MARK: Layout UI
extension WeatherDetailView {
    private func layoutUI() {
        layoutMainStackView()
        layoutIconImageView()
    }
    
    private func layoutMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func layoutIconImageView() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
    }
}
