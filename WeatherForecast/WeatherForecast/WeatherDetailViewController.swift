//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {

    private var detailView: WeatherDetailView?
    private var weatherForecastInfo: WeatherForecastInfo?
    private var cityInfo: City?
    private var tempUnit: TempUnit
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    init(weatherForecastInfo: WeatherForecastInfo?,
         cityInfo: City?,
         tempUnit: TempUnit = .metric
    ) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        detailView = WeatherDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }

    private func initialSetUp() {
        view.backgroundColor = .white
        
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = dateFormatter.string(from: date)
       
        detailView?.configure(with: listInfo,
                              cityInfo: cityInfo,
                              tempUnit: tempUnit)                              
    }
}
