//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {
    var weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City
    var tempUnit: TempUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: City, tempUnit: TempUnit = .metric) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let weatherDetailView: WeatherDetailView = .init(
            weatherForecastInfo: weatherForecastInfo,
            cityInfo: cityInfo,
            tempUnit: tempUnit
        )
        view = weatherDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        let date: Date = .init(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = date.toString(type: .full)
    }
}
