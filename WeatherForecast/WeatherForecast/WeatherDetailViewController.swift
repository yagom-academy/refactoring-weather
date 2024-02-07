//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

struct WeatherDetailInfo {
    var weatherForecastInfo: WeatherForecastInfo
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
}

final class WeatherDetailViewController: UIViewController {

    private let weatherDetailInfo: WeatherDetailInfo
    private let networkManager: NetworkManager
    private let dateFormatter: DateFormattable
    
    init(weatherDetailInfo: WeatherDetailInfo,
         networkManager: NetworkManager = NetworkManager(),
         dateFormatter: DateFormattable = CustomDateFormatter(dateFormat: "yyyy-MM-dd(EEEE) a HH:mm")
    ) {
        self.weatherDetailInfo = weatherDetailInfo
        self.networkManager = networkManager
        self.dateFormatter = dateFormatter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherDetailView(networkManager: self.networkManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }

    private func initialSetUp() {
        view.backgroundColor = .white
        
        let listInfo = weatherDetailInfo.weatherForecastInfo
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        let title: String = dateFormatter.string(from: date)
        
        navigationItem.title = title
       
        (view as? WeatherDetailView)?.configure(with: weatherDetailInfo)
    }
}
