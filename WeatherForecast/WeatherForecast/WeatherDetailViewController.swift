//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


struct DateFormat {
    var dataFormater: String?
    let locale = "ko_KR"
    let dateFormatStyle: DateFormatter.Style
    
    init(dataFormater: String?, dateFormatStyle: DateFormatter.Style) {
        self.dataFormater = dataFormater
        self.dateFormatStyle = dateFormatStyle
    }
}

enum DetailGroupList: String {
    case temperature = "현재 기온 : "
    case feelsLike = "체감 기온 : "
    case maximumTemperature = "최고 기온 : "
    case minimumTemperature = "최저 기온 : "
    case pop = "강수 확률 : "
    case humidity = "습도 : "
    case sunriseTime = "일출 : "
    case sunsetTime = "일몰 : "
}

struct DataCase {
    static let long = "yyyy-MM-dd(EEEEE) a HH:mm"
    
}

class WeatherDetailViewController: UIViewController {

    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white
        
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = Utils.dateSetUp(DataCase.long).string(from: date)
        
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
        
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        temperatureLabel.text = "\(DetailGroupList.temperature) \(listInfo.main.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "\(DetailGroupList.feelsLike) \(listInfo.main.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "\(DetailGroupList.maximumTemperature)\(listInfo.main.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "\(DetailGroupList.minimumTemperature)\(listInfo.main.tempMin)\(tempUnit.expression)"
        popLabel.text = "\(DetailGroupList.pop)\(listInfo.main.pop * 100)%"
        humidityLabel.text = "\(DetailGroupList.humidity) \(listInfo.main.humidity)%"
        
        if let cityInfo {
            sunriseTimeLabel.text = "\(DetailGroupList.sunriseTime) \(Utils.dateSetUp(nil).string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "\(DetailGroupList.sunsetTime) \(Utils.dateSetUp(nil).string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
        
        weatherTask(iconName: listInfo.weather.icon, imageView: iconImageView)
        
    }
}

extension WeatherDetailViewController {
    //이미지 처리
    func weatherTask(iconName: String, imageView: UIImageView) {
        Task {
            let iconName: String = iconName
            let urlString: String = "\(ImageURLType.path.rawValue)\(iconName)\(ImageURLType.png.rawValue)"
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            imageView.image = image
        }
    }
    
}
