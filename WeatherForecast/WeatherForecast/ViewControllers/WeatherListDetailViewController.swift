//
//  WeatherForecast - WeatherDetailViewController.swift -> WeatherListDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherListDetailViewController: UIViewController {

    let model: WeatherListDetailViewModel
    
    init(model: WeatherListDetailViewModel = .init(dataRequester: DataRequester())) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        
        func setImage(in view: UIImageView?) {
            Task {
                guard let iconName = model.iconName else { return }
                let urlString: String = model.urlStringForIconRequest(iconName: iconName)
                guard let imageData: Data = await model.weatherIconImageDataAfterRequest(urlString: urlString) else {
                    return
                }
                let dataToImage: UIImage? = imageData.toUIImage()
                
                DispatchQueue.main.async {
                    view?.image = dataToImage
                }
            }
        }
        
        func setLabelText(listInfo: WeatherForecastInfo, cityInfo: City) {
            weatherGroupLabel.text = listInfo.weather.main
            weatherDescriptionLabel.text = listInfo.weather.description
            temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(model.tempUnit.expressStrategy.expression)"
            feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(model.tempUnit.expressStrategy.expression)"
            maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(model.tempUnit.expressStrategy.expression)"
            minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(model.tempUnit.expressStrategy.expression)"
            popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
            humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
            sunriseTimeLabel.text = "일출 : \(cityInfo.sunrise.toDate().toString(timeStyle: .short))"
            sunsetTimeLabel.text = "일몰 : \(cityInfo.sunset.toDate().toString(timeStyle: .short))"
        }
        
        func setNavigationTitle(_ value: String) {
            navigationItem.title = value
        }
        
        view.backgroundColor = .white
                
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
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
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
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
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
        
        guard let listInfo = model.weatherForecastInfo else { return }
        guard let cityInfo = model.cityInfo else { return }
        
        setNavigationTitle(listInfo.dt.toDate().toString(format: WeatherDate.format))
        setLabelText(listInfo: listInfo, cityInfo: cityInfo)
        setImage(in: iconImageView)
    }
}
