//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    private var weatherView: WeatherView!
    
    var weatherJSON: WeatherJSON? {
        didSet {
            navigationItem.title = weatherJSON?.city.name
        }
    }
    
    let imageCache: NSCache<NSString, UIImage> = NSCache()
    var tempUnit: TempUnit = .metric
    
    override func loadView() {
        weatherView = WeatherView(delegate: self)
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "화씨"
        }
        weatherView.reloadData()
    }
    
    
    private func initialSetUp() {
        setupNavigationItem()
        setupWeatherView()
    }
    
    private func setupNavigationItem() {
        let rightBarButtonItem: UIBarButtonItem = .init(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupWeatherView() {
        weatherView.setupTableViewDelegate(with: self)
        weatherView.setupTableViewDataSource(with: self)
    }
}

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.configure(
            with: weatherForecastInfo,
            tempUnit: tempUnit,
            imageService: ImageService(),
            imageCache: imageCache
        )
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let weatherJSON {
            let detailViewController: WeatherDetailViewController = .init(
                weatherForecastInfo: weatherJSON.weatherForecast[indexPath.row],
                cityInfo: weatherJSON.city,
                tempUnit: tempUnit
            )
            navigationController?.show(detailViewController, sender: self)
        }
    }
}


extension WeatherViewController: WeatherViewDelegate {
    func fetchWeatherJSON() {
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
    }
}
