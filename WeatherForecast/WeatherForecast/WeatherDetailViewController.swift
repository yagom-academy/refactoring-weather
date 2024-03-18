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
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    override func loadView() {
        guard let weatherForecastInfo,
              let cityInfo else {return}
        
        view = DetailView(weatherForecastInfo: weatherForecastInfo, cityInfo: cityInfo, tempUnit: tempUnit)
        layViews()
    }
    
    private func layViews() {
        view.backgroundColor = .white
        
        guard let weatherForecastInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = dateFormatter.string(from: date)
    }
}
