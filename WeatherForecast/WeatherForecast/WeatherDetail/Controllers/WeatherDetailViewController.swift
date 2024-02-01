//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {
    //MARK: - Properties
    private let weatherDetailInfo: WeatherDetailInfo
    
    //MARK: - Init
    init(weatherDetailInfo: WeatherDetailInfo) {
        print("WeatherDetailViewController - init()")
        self.weatherDetailInfo = weatherDetailInfo
        super.init(nibName: nil, bundle: nil)
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func loadView() {
        view = WeatherDetailView(weatherDetailInfo: weatherDetailInfo,
                                 imageService: ImageService())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Layout
    private func initialSetUp() {
        navigationItem.title = weatherDetailInfo.date
    }
}
