//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit
import Combine

final class WeatherDetailView: UIView {
    private let iconImageView: UIImageView = UIImageView()
    private let weatherGroupLabel: UILabel = UILabel()
    private let weatherDescriptionLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let feelsLikeLabel: UILabel = UILabel()
    private let maximumTemperatureLable: UILabel = UILabel()
    private let minimumTemperatureLable: UILabel = UILabel()
    private let popLabel: UILabel = UILabel()
    private let humidityLabel: UILabel = UILabel()
    private let sunriseTimeLabel: UILabel = UILabel()
    private let sunsetTimeLabel: UILabel = UILabel()
    
    private let weather: WeatherForecastInfo
    private let cityInfo: City
    private let tempUnit: TempUnit
    
    private let imageFetcher: ImageFetcher
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        weather: WeatherForecastInfo,
        cityInfo: City,
        tempUnit: TempUnit,
        imageFetcher: ImageFetcher
    ) {
        self.weather = weather
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        self.imageFetcher = imageFetcher
        
        super.init(frame: .zero)
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        layoutViews()
        updateUI()
    }
}

extension WeatherDetailView {
    private func layoutViews() {
        backgroundColor = .white
        let mainStackView = createMainStackView()
        
        setUpConstrains(mainStackView: mainStackView)
    }
    
    private func createMainStackView() -> UIStackView {
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
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
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        addSubview(mainStackView)
        
        return mainStackView
    }
    
    private func setUpConstrains(mainStackView: UIStackView) {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
}

extension WeatherDetailView {
    
    private func updateUI() {
        weatherGroupLabel.text = weather.mainString
        weatherDescriptionLabel.text = weather.description
        temperatureLabel.text = "현재 기온 : \(tempUnit.convert(weather.temperature))"
        feelsLikeLabel.text = "체감 기온 : \(tempUnit.convert(weather.feelsLike))"
        maximumTemperatureLable.text = "최고 기온 : \(tempUnit.convert(weather.maximumTemperature))"
        minimumTemperatureLable.text = "최저 기온 : \(tempUnit.convert(weather.minimumTemperature))"
        popLabel.text = "강수 확률 : \(weather.rainProbabilityString)"
        humidityLabel.text = "습도 : \(weather.humidityString)"
        
        sunriseTimeLabel.text = "일출 : \(cityInfo.sunriseString)"
        sunsetTimeLabel.text = "일몰 : \(cityInfo.sunsetString)"
        
        fetchIconImage(weather.iconUrlString)
    }
    
    private func fetchIconImage(_ iconImageUrlString: String) {
        guard let url = URL(string: iconImageUrlString) else { return }
        imageFetcher.loadImage(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    // handle error
                    print(error)
                }
            }, receiveValue: { [weak self] fetchedImage in
                guard let self else { return }
                
                iconImageView.image = fetchedImage
            }).store(in: &cancellables)
    }
}
