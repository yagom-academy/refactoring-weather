//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var mainView: MainView?
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var tempUnit: TempUnit = .metric
    
    override func loadView() {
        mainView = MainView(delegate: self,
                        tableViewDelegate: self,
                        tableViewDataSource: self)
        view = mainView
    }
    
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
    
    @objc private func refresh() {
        fetchWeatherJSON()
        mainView?.refreshEnd()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
    }
}

extension ViewController {
    private func fetchWeatherJSON() {
        
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }

        weatherJSON = info
        navigationItem.title = weatherJSON?.city.name
    }
}

// MARK: - MainViewDelegate
extension ViewController: MainViewDelegate {
    func refreshTableView() {
        refresh()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        else {
            return cell
        }
        
        cell.configure(with: weatherForecastInfo, 
                       tempUnit: tempUnit,
                       imageCache: imageCache)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        showDetailViewController(with: weatherForecastInfo)
    }
    
    private func showDetailViewController(with weatherForecastInfo: WeatherForecastInfo?) {
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherForecastInfo: weatherForecastInfo,
                                                                                            cityInfo: weatherJSON?.city, tempUnit: tempUnit)
//        detailViewController.weatherForecastInfo = weatherForecastInfo
//        detailViewController.cityInfo = weatherJSON?.city
//        detailViewController.tempUnit = tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}


