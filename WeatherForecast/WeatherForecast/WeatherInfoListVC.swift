//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherInfoListVC: UIViewController {
    
    // MARK: - Properties
    private var tempUnit: TemperatureUnit
    private var weatherInfoListView: WeatherInfoListView!
    
    // MARK: - Init
    init(tempUnit: TemperatureUnit) {
        self.tempUnit = tempUnit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        setupWeatherInfoListView()
    }
    
    // MARK: - SetupUI
    private func initialSetUp() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: tempUnit.description,
                                                            image: nil,
                                                            target: self,
                                                            action: #selector(changeTempUnit))
    }
    
    private func setupWeatherInfoListView() {
        weatherInfoListView = .init(delegate: self, fetchDataManager: FetchDataManager(), tempUnit: self.tempUnit)
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
        tempUnit.toggle()
        navigationItem.rightBarButtonItem?.title = tempUnit.description
        weatherInfoListView.changeTempUnit(to: tempUnit)
        weatherInfoListView.refresh()
    }
    
}

// MARK: - WeatherInfoListViewProtocol delegate methods
extension WeatherInfoListVC: WeatherInfoListViewProtocol {
    
    func fetchCityName(_ cityName: String) {
        navigationItem.title = cityName
    }
    
    func fetchWeatherDetailVC(_ detailVC: WeatherDetailVC) {
        navigationController?.show(detailVC, sender: self)
    }
}


