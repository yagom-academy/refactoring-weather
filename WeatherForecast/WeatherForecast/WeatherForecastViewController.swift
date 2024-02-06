//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherForecastViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    var tempUnit: TempUnit = .metric
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherForecastViewController {
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
        loadJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func layTable() {
        tableView = .init(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension WeatherForecastViewController {
    private func loadJSON() {
        weatherJSON = TransforJSON.shared.fetchWeatherJSON(weatherInfo: weatherJSON)
        navigationItem.title = weatherJSON?.city.name
    }
}

extension WeatherForecastViewController: UITableViewDataSource {
    
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
        let weatherDetailInfo = WeatherDetailInfo(weatherForecast: weatherForecastInfo)
        cell.configure(info: weatherDetailInfo, tempUnit: tempUnit)
        return cell
    }
}

extension WeatherForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let weatherForecast = weatherJSON?.weatherForecast[indexPath.row],let cityInfo = weatherJSON?.city else {return}
        
        let weatherDetailInfo = WeatherDetailInfo(
            weatherForecast: weatherForecast)
        let cityDetailInfo = CityDetailInfo(city: cityInfo)
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherInfo: weatherDetailInfo, cityInfo: cityDetailInfo, tempUnit: tempUnit)
        navigationController?.show(detailViewController, sender: self)
    }
    
}
struct WeatherDetailInfo {
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    var weatherForecast: WeatherForecastInfo
    var mainWeather: String
    var currentTemp: Double
    var feelsLikeTemp: Double
    var maxTemp: Double
    var minTemp: Double
    var pop: Double
    var humidity: Double
    var description: String
    var date: String
    var iconImageUrl: String
    
    init(weatherForecast: WeatherForecastInfo) {
        self.weatherForecast = weatherForecast
        self.mainWeather = weatherForecast.weather.main
        self.currentTemp = weatherForecast.main.temp
        self.feelsLikeTemp = weatherForecast.main.feelsLike
        self.maxTemp = weatherForecast.main.tempMax
        self.minTemp = weatherForecast.main.tempMin
        self.pop = weatherForecast.main.pop
        self.humidity = weatherForecast.main.humidity
        self.description = weatherForecast.weather.description
        self.date = dateFormatter.string(from: Date(timeIntervalSince1970: weatherForecast.dt))
        self.iconImageUrl = weatherForecast.weather.icon
    }
}
struct CityDetailInfo {
    
    let formatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }()
    
    var city: City
    var sunrise: String {
        return "\(formatter.string(from: Date(timeIntervalSince1970: city.sunrise)))"
    }
    var sunset: String {
        return "\(formatter.string(from: Date(timeIntervalSince1970: city.sunset)))"
    }
    init(city: City) {
        self.city = city
    }
}
