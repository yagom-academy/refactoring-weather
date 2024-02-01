//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailVC: UIViewController {
    
    // MARK: - Properties
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
    }
    
    
    // MARK: - SetupUI
    
    private func initialSetUp() {
        if let info = weatherForecastInfo {
            let date: Date = Date(timeIntervalSince1970: info.dt)
            navigationItem.title = dateFormatter.string(from: date)
        }
    }
}
