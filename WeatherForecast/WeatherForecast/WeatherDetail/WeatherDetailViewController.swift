//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

struct WeatherDetailInfo {
    let weatherForecastInfo: WeatherForecastInfo?
    let cityInfo: City?
    let tempUnit: TempUnit
}

class WeatherDetailViewController: UIViewController, WeatherDetailDelegate {
    
    private let weatherAPI: WeatherAPI
    var weatherDetailInfo: WeatherDetailInfo
    
    init(weatherDetailInfo: WeatherDetailInfo, weatherAPI: WeatherAPI) {
        self.weatherDetailInfo = weatherDetailInfo
        self.weatherAPI = weatherAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherDeatilView(weatherDetailInfo: weatherDetailInfo, weatherAPI: weatherAPI, delegate: self)
    }
}
