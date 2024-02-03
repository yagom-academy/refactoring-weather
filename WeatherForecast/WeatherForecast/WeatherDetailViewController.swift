//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {

    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
    
    override func loadView() {
        let weatherDetailView: WeatherDetailView = WeatherDetailView(
            weatherForecastInfo: weatherForecastInfo!
        )
        
        weatherDetailView.cityInfo = cityInfo
        weatherDetailView.tempUnit = tempUnit
        view = weatherDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        navigationItem.title = dateFormatter.string(from: date)
    }
}
