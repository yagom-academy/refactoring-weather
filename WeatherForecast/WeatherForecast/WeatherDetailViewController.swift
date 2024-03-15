//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {
    var weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City
    var tempUnit: TempUnit = .metric
    private let weatherApi: WeatherApi
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit, weatherApi: WeatherApi) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        self.weatherApi = weatherApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherDeatilView(weatherForecastInfo: weatherForecastInfo, tempUnit: tempUnit, cityInfo: cityInfo, weatherApi: weatherApi, delegate: self)
    }
}

extension WeatherDetailViewController: WeatherDetailDelegate {
    func dateDidChanged(text: String) {
        self.navigationItem.title = text
    }
}
