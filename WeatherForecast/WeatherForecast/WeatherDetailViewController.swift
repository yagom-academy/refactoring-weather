//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

struct WeatherDetailInfo {
    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
}

final class WeatherDetailViewController: UIViewController {

    private let weatherDetailInfo: WeatherDetailInfo?
    
    init(weatherDetailInfo: WeatherDetailInfo?) {
        self.weatherDetailInfo = weatherDetailInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }

    private func initialSetUp() {
        view.backgroundColor = .white
        
        guard let listInfo = weatherDetailInfo?.weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = detailDateFormatter.string(from: date)
       
        (view as? WeatherDetailView)?.configure(with: weatherDetailInfo)
    }
}

// MARK: - DetailDateFormattable
extension WeatherDetailViewController: DetailDateFormattable { }
