//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    private var weatherForecastInfo: WeatherForecastInfo?
    private var cityInfo: City?
    private var tempUnit: TempUnit = .celsius
    
    init(weatherForecastInfo: WeatherForecastInfo? = nil, cityInfo: City? = nil, tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let weatherDetailView: WeatherDetailView = WeatherDetailView(
            weatherForecastInfo: weatherForecastInfo!,
            dataFetcher: DataFetcher()
        )
        
        view = weatherDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        if let timezone = TimeZone(identifier: "ko-KR") {
            navigationItem.title = date.toString(locale: Locale(identifier: "ko-KR"), timezone: TimeZone(identifier: "ko-KR") ?? TimeZone(identifier: "ko-KR")!)
        }
    }
}

