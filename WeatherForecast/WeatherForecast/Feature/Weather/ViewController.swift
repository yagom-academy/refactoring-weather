//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

class ViewController: UIViewController {
    var tempUnit: TempUnit = .metric
    private var weatherRepository: WeatherRepository = WeatherRepositoryImpl()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension ViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "화씨"
        }
        refresh()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        view = WeatherListView(delegate: self)
        
        refresh()
    }
}

extension ViewController: WeatherListViewDelegate {
    func weatherListView(_ weatherListView: WeatherListView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
//        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
//        detailViewController.cityInfo = weatherJSON?.city
//        detailViewController.tempUnit = tempUnit
//        navigationController?.show(detailViewController, sender: self)
    }
    
    func refresh() {
        weatherRepository.fetchWeather()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    // handle error
                    print(error)
                }
            } receiveValue: { [weak self] fetchResult in
                guard let self, let view = view as? WeatherListView else { return }
                
                view.updateUI(fetchResult, tempUnit)
            }.store(in: &cancellables)
    }
}
