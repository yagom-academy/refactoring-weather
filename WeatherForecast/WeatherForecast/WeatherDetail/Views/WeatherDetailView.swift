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
        
        makeLabel()
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
    
    func makeLabel() {
        weatherGroupLabel.makeWeatherDetailLabel(font: .preferredFont(forTextStyle: .largeTitle))
        weatherDescriptionLabel.makeWeatherDetailLabel(font: .preferredFont(forTextStyle: .largeTitle))
        temperatureLabel.makeWeatherDetailLabel()
        feelsLikeLabel.makeWeatherDetailLabel()
        maximumTemperatureLable.makeWeatherDetailLabel()
        minimumTemperatureLable.makeWeatherDetailLabel()
        popLabel.makeWeatherDetailLabel()
        humidityLabel.makeWeatherDetailLabel()
        sunriseTimeLabel.makeWeatherDetailLabel()
        sunsetTimeLabel.makeWeatherDetailLabel()
    }
    
    private func updateLabel() {
        weatherGroupLabel.text          = weatherDetailInfo.weatherMain
        weatherDescriptionLabel.text    = weatherDetailInfo.description
        temperatureLabel.text           = "현재 기온 : \(weatherDetailInfo.temp)"
        feelsLikeLabel.text             = "체감 기온 : \(weatherDetailInfo.feelsLike)"
        maximumTemperatureLable.text    = "최고 기온 : \(weatherDetailInfo.tempMax)"
        minimumTemperatureLable.text    = "최저 기온 : \(weatherDetailInfo.tempMin)"
        popLabel.text                   = "강수 확률 : \(weatherDetailInfo.pop)"
        humidityLabel.text              = "습도 : \(weatherDetailInfo.humidity)"
        sunriseTimeLabel.text           = "일출 : \(weatherDetailInfo.sunrise)"
        sunsetTimeLabel.text            = "일몰 : \(weatherDetailInfo.sunset)"
    }
    
    private func updateIcon() {
        imageService.getIcon(iconName: weatherDetailInfo.iconName, urlSession: URLSession.shared) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
