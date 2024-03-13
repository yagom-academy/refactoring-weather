//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by 홍승완 on 2024/03/13.
//

import UIKit

final class WeatherDetailView: UIView {
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
    let mainStackView: UIStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        [iconImageView,
         weatherGroupLabel,
         weatherDescriptionLabel,
         temperatureLabel,
         feelsLikeLabel,
         maximumTemperatureLable,
         minimumTemperatureLable,
         popLabel,
         humidityLabel,
         sunriseTimeLabel,
         sunsetTimeLabel,
         spacingView
        ].forEach { view in
            mainStackView.addArrangedSubview(view)
        }
                
        mainStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }

        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayout() {
        let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                     mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                                            constant: 16),
                                     mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                                             constant: -16),
                                     iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
                                     iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                                          multiplier: 0.3)])
    }
}
