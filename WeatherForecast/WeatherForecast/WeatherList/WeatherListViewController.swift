//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherListViewController: UIViewController {

    var weatherJSON: WeatherJSON?
    var tempUnit: TempUnit = .metric
    var weatherAPI: WeatherAPI = OpenWeatherAPI()
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    override func loadView() {
        view = WeatherListView(delegate: self)
    }
    
}

extension WeatherListViewController: WeatherListViewDelegate {
    func changeTempUnit() -> String {
        let newTempUnit: TempUnit = tempUnit == .imperial ? .metric : .imperial
        self.tempUnit = newTempUnit
        refresh()
        
        return tempUnit.title
    }
    
    func refresh() {
        self.fetchWeatherJSON()
    }
}

extension WeatherListViewController {
    private func fetchWeatherJSON() {
        weatherAPI.fetchData { [weak self] info in
            self?.weatherJSON = info
            self?.navigationItem.title = info.city.name
        }
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.setData(weatherForecastInfo: weatherForecastInfo, tempUnit: tempUnit)
        
        let iconName: String = weatherForecastInfo.weather.icon
        weatherAPI.fetchImage(iconName: iconName) { image in
            cell.setImage(image: image)
        }
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let weatherDetailInfo = WeatherDetailInfo(weatherForecastInfo: weatherJSON?.weatherForecast[indexPath.row], cityInfo: weatherJSON?.city, tempUnit: tempUnit)
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherDetailInfo: weatherDetailInfo, weatherAPI: weatherAPI)
        navigationController?.show(detailViewController, sender: self)
    }
}


