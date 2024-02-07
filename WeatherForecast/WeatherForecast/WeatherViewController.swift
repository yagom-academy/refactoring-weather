//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    private var dataManagerDelegate: WeatherDataManagerDelegate
    private var weatherJSON: WeatherJSON?
    
    private var tempUnit: TempUnit = .metric
    
    init(dataManagerDelegate: WeatherDataManagerDelegate) {
        self.dataManagerDelegate = dataManagerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherView(delegate: self,
                           tableViewDelegate: self,
                           tableViewDataSource: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
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
        refresh()
    }
    
    @objc private func refresh() {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        dataManagerDelegate.fetchWeatherData(jsonDecoder: jsonDecoder,
                                             dataAsset: "weather"
        ) { [weak self] (result: Result<WeatherJSON, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.weatherJSON = info
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        navigationItem.title = weatherJSON?.city.name
        (view as? WeatherView)?.refreshEnd()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
    }
}

// MARK: - MainViewDelegate
extension WeatherViewController: WeatherViewDelegate {
    func refreshTableView() {
        refresh()
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellId, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[safe: indexPath.row]
        else {
            return cell
        }
        
        cell.configure(with: weatherForecastInfo,
                       tempUnit: tempUnit)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let weatherJSON,
              let weatherForecast = weatherJSON.weatherForecast[safe: indexPath.row]
        else { return }
        
        let weatherDetailInfo: WeatherDetailInfo = .init(
            weatherForecastInfo: weatherForecast,
            cityInfo: weatherJSON.city,
            tempUnit: tempUnit)
        
        showDetailViewController(with: weatherDetailInfo)
    }
    
    private func showDetailViewController(with weatherDetailInfo: WeatherDetailInfo) {
        let detailViewController: WeatherDetailViewController = .init(
            weatherDetailInfo: weatherDetailInfo)
        navigationController?.show(detailViewController, sender: self)
    }
}
