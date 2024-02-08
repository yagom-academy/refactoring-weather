//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailVC: UIViewController {
    
    // MARK: - Properties
    var weatherForecastInfo: WeatherForecast?
    var cityInfo: CityInfo?
    
    // MARK: - Init
    init(weatherForecastInfo: WeatherForecast?, cityInfo: CityInfo?) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = WeatherDetailView(imageManager: ImageManager(),
                                 weatherForecastInfo: weatherForecastInfo,
                                 cityInfo: cityInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    
    // MARK: - SetupUI
    
    private func initialSetUp() {
        if let info = weatherForecastInfo {
            navigationItem.title = info.longFormattedDate
        }
    }
}
