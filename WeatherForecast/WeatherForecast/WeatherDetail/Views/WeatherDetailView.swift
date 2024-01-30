//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/29/24.
//

import UIKit


final class WeatherDetailView: UIView {
    //MARK: - Properties
    private let weatherDetailInfo: WeatherDetailInfoCoordinator
    private let imageService: ImageServiceable
    
    //MARK: - UI
    private let iconImageView           : UIImageView   = UIImageView()
    private let weatherGroupLabel       : UILabel       = UILabel()
    private let weatherDescriptionLabel : UILabel       = UILabel()
    private let temperatureLabel        : UILabel       = UILabel()
    private let feelsLikeLabel          : UILabel       = UILabel()
    private let maximumTemperatureLable : UILabel       = UILabel()
    private let minimumTemperatureLable : UILabel       = UILabel()
    private let popLabel                : UILabel       = UILabel()
    private let humidityLabel           : UILabel       = UILabel()
    private let sunriseTimeLabel        : UILabel       = UILabel()
    private let sunsetTimeLabel         : UILabel       = UILabel()
    private let spacingView             : UIView        = UIView()
    
    //MARK: - Init
    init(weatherDetailInfo: WeatherDetailInfoCoordinator,
         imageService: ImageServiceable) {
        self.weatherDetailInfo = weatherDetailInfo
        self.imageService = imageService
        super.init(frame: .zero)
        layoutview()
        updateLabel()
        updateIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    private func layoutview() {
        backgroundColor = .white
        
        let mainStackView: UIStackView = .init(arrangedSubviews: [
            iconImageView,
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
        ])
        
        mainStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                   constant: -16),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                 multiplier: 0.3)
        ])
    }
    
    private func updateLabel() {
        weatherGroupLabel.text          = weatherDetailInfo.getWeather()
        weatherDescriptionLabel.text    = weatherDetailInfo.getDescription()
        temperatureLabel.text           = "현재 기온 : \(weatherDetailInfo.getTemp())"
        feelsLikeLabel.text             = "체감 기온 : \(weatherDetailInfo.getFeelsLike())"
        maximumTemperatureLable.text    = "최고 기온 : \(weatherDetailInfo.getTempMax())"
        minimumTemperatureLable.text    = "최저 기온 : \(weatherDetailInfo.getTempMin())"
        popLabel.text                   = "강수 확률 : \(weatherDetailInfo.getPop())"
        humidityLabel.text              = "습도 : \(weatherDetailInfo.getHumidity())"
        sunriseTimeLabel.text           = "일출 : \(weatherDetailInfo.sunrise)"
        sunsetTimeLabel.text            = "일몰 : \(weatherDetailInfo.sunset)"
    }
    
    private func updateIcon() {
        imageService.getIcon(iconName: weatherDetailInfo.getIconName()) { image in
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
}
