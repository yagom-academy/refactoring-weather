//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    private var weatherView: WeatherView!
    
    private var weather: Weather? {
        didSet {
            navigationItem.title = weather?.city.name
        }
    }
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    private var tempUnit: TempUnit = .celsius
    
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
        tempUnit.toggleTempUnit()
        navigationItem.rightBarButtonItem?.title = tempUnit.strategy.expressionText
        
        updateTemperature()
        weatherView.reloadData()
    }
    
    private func updateTemperature() {
        // TODO: 온도 단위에 따라 변환하기 작업 추가 in STEP BONUS
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
        if let count: Int = weather?.weatherForecast.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo: WeatherForecastInfo = weather?.weatherForecast[indexPath.row] else {
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
        
        if let weather {
            let detailViewController: WeatherDetailViewController = .init(
                weatherForecastInfo: weather.weatherForecast[indexPath.row],
                cityInfo: weather.city,
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
        
        guard let data: Data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSONDTO
        do {
            info = try jsonDecoder.decode(WeatherJSONDTO.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        weather = info.toEntity()
    }
}
