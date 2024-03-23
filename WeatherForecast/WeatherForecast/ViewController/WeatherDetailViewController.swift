//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    private let info: DetailInfo
    
    init(info: DetailInfo) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DetailView(weatherForecastInfo: info.weatherForecastInfo, cityInfo: info.cityInfo)
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        let weatherForecastInfo = info.weatherForecastInfo
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = DateFormatter.KRFullFormat.string(from: date)
    }
}
