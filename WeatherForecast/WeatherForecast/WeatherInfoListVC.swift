//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class WeatherInfoListVC: UIViewController {
    
    // MARK: - Properties
    var tempUnit: TemperatureUnit = .metric
    var weatherInfoListView: WeatherInfoListView!
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherInfoListView()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
    }
    
    // MARK: - SetupUI
    private func setupWeatherInfoListView() {
        weatherInfoListView = .init(fetchDataManager: FetchDataManager(),
                                    imageManager: ImageManager())
        view.addSubview(weatherInfoListView)
        weatherInfoListView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            weatherInfoListView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherInfoListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherInfoListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            weatherInfoListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    // MARK: - Methods
    @objc private func changeTempUnit() {
        switch tempUnit {
            case .imperial:
                tempUnit = .metric
                navigationItem.rightBarButtonItem?.title = "섭씨"
            case .metric:
                tempUnit = .imperial
                navigationItem.rightBarButtonItem?.title = "화씨"
        }
    }
    
}


