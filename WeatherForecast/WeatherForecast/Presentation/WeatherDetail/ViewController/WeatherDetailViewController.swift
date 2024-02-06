//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    // MARK: - Properties
    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    // MARK: - Init
    init(weatherForecastInfo: WeatherForecastInfo? = nil,
         cityInfo: City? = nil,
         tempUnit: TempUnit) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = WeatherDetailView(weatherForcastInfo: weatherForecastInfo,
                                 cityInfo: cityInfo,
                                 tempUnit: tempUnit,
                                 imageService: WeatherIconImageService())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        navigationItem.title = weatherForecastInfo?.dtTxt
    }
}
