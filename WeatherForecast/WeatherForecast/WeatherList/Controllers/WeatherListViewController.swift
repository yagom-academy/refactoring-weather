//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {
    //MARK: - Properties
    var weatherListView: WeatherListView!
    var weatherInfo: WeatherInfoCoordinator
    
    //MARK: - Init
    init(weatherInfo: WeatherInfoCoordinator) {
        self.weatherInfo = weatherInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        layoutWeatherListView()
    }
    
    //MARK: - Layout
    private func initialSetUp() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(toggleTempUnit))
    }
    
    private func layoutWeatherListView() {
        weatherListView = .init(weatherInfo: weatherInfo,
                                imageService: ImageService(),
                                jsonService: JsonService())
        view.addSubview(weatherListView)
        weatherListView.translatesAutoresizingMaskIntoConstraints = false
        weatherListView.delegate = self
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weatherListView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            weatherListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc private func toggleTempUnit() {
        navigationItem.rightBarButtonItem?.title = weatherInfo.getTempExpressionTitle()
        weatherInfo.toggleTempUnit()
        weatherListView.refresh()
    }
}

//MARK: - Extension WeatherListViewDelegate
extension WeatherListViewController: WeatherListViewDelegate {
    func selectWeatherItem(detailViewController: WeatherDetailViewController) {
        navigationController?.show(detailViewController, sender: self)
    }
    
    func changeNavigationTitle(title: String?) {
        navigationItem.title = title
    }
}
