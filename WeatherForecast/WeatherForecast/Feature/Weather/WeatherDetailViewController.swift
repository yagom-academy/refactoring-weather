//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {

    private var weatherForecastInfo: WeatherForecastInfo
    private var cityInfo: City
    private var tempUnit: TempUnit = .metric
    
    private var imageFetcher: ImageFetcher
    
    init(
        weatherForecastInfo: WeatherForecastInfo,
        cityInfo: City,
        tempUnit: TempUnit,
        imageFetcher: ImageFetcher
    ) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        self.imageFetcher = imageFetcher
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        navigationItem.title = weatherForecastInfo.dt.weatherDateString
        
        view = WeatherDetailView(
            weather: weatherForecastInfo,
            cityInfo: cityInfo,
            tempUnit: tempUnit,
            imageFetcher: imageFetcher
        )
    }
}
