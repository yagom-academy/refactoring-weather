//
//  WeatherListViewController.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/13/24.
//

import UIKit

final class WeatherListViewController: UIViewController {
    var weatherJSON: WeatherJSON? {
        didSet { NotificationCenter.default.post(name: .init(WeatherJSON.changeWeaterJsonKey), object: nil) }
    }
    var tempUnit: TempUnit = Metric()
    var weatherApi: WeatherApi
    
    init(weatherApi: WeatherApi) {
        self.weatherApi = weatherApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WeatherListView(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { try await fetchWeatherJSON() }
    }
}

extension WeatherListViewController: WeatherListViewDelegate {
    func changeTempUnit() -> String {
        let newTempUnit: TempUnit = tempUnit is Metric ? Imperial() : Metric()
        self.tempUnit = newTempUnit
        refresh()

        return tempUnit.buttonTitle
    }

    func refresh() {
        Task { try await fetchWeatherJSON() }
    }
}

extension WeatherListViewController {
    private func fetchWeatherJSON() async throws {
        self.weatherJSON = try await weatherApi.fetchData()
        self.navigationItem.title = weatherJSON?.city.name
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherTableViewCell = .dequeueReusableCell(superView: tableView, indexPath: indexPath)

        guard let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }

        cell.configureCell(with: weatherForecastInfo, tempUnit: tempUnit)

        let iconName: String = weatherForecastInfo.weather.icon
        let imageUrlString = weatherApi.iconImageUrlString(iconName: iconName)
        cell.setImage(with: imageUrlString)

        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let weatherForcastInfo = weatherJSON?.weatherForecast[indexPath.row],
              let cityInfo = weatherJSON?.city else {
            return
        }
        let detailViewController: WeatherDetailViewController = .init(weatherForecastInfo: weatherForcastInfo, cityInfo: cityInfo, tempUnit: tempUnit, weatherApi: weatherApi)
        navigationController?.show(detailViewController, sender: self)
    }
}
