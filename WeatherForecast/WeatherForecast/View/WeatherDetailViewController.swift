//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    private let weatherForecastInfo: WeatherForecastInfo
    private let cityInfo: CityInfo
    private let tempUnit: TempUnit
    
    init(weatherForecastInfo: WeatherForecastInfo, cityInfo: CityInfo, tempUnit: TempUnit = .celsius) {
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
            tempUnit: tempUnit,
            imageService: ImageService()
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
