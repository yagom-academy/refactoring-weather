//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailVC: UIViewController {
    
    // MARK: - Properties
//    private var weatherDetailView: WeatherDetailView!
    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TemperatureUnit = .metric
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    // MARK: - Init
    init(weatherForecastInfo: WeatherForecastInfo?, cityInfo: City?, tempUnit: TemperatureUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = WeatherDetailView(imageManager: ImageManager(),
                                 weatherForecastInfo: weatherForecastInfo,
                                 cityInfo: cityInfo,
                                 tempUnit: tempUnit)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
//        setupWeatherDetailView()
    }
    
    
    // MARK: - SetupUI
    
    private func initialSetUp() {
        if let info = weatherForecastInfo {
            let date: Date = Date(timeIntervalSince1970: info.dt)
            navigationItem.title = dateFormatter.string(from: date)
        }
    }
    
//    let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
//    dateLabel.text = dateFormatter.string(from: date)
    
//    private func setupWeatherDetailView() {
//        weatherDetailView = .init(imageManager: ImageManager(),
//                                  weatherForecastInfo: weatherForecastInfo,
//                                  cityInfo: cityInfo,
//                                  tempUnit: tempUnit)
//        
//        view.addSubview(weatherDetailView)
//        
//        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            weatherDetailView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            weatherDetailView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//            weatherDetailView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
//            weatherDetailView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
//        ])
//    }
}
