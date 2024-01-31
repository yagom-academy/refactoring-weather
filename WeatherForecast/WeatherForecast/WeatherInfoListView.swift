//
//  WeatherInfoListView.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

final class WeatherInfoListView: UIView {

    // MARK: - Properties
    var fetchDataManager: FetchDataManagerProtocol
    var imageManager: ImageManagerProtocol
    var weatherJSON: WeatherJSON?
    var tempUnit: TemperatureUnit = .metric
    
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    // MARK: - Init
    init(fetchDataManager: FetchDataManagerProtocol, imageManager: ImageManagerProtocol) {
        self.fetchDataManager = fetchDataManager
        self.imageManager = imageManager
        super.init(frame: .zero)
        layoutTableView()
        setUpTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func layoutTableView() {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        tableView = .init(frame: .zero, style: .plain)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setUpTableView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func refresh() {
        fetchDataManager.fetchWeatherJSON { [weak self] weatherJSON in
            if let data = weatherJSON {
                self?.weatherJSON = data
                self?.tableView.reloadData()
//                self?.navigationItem.title = data.city.name
            } else {
                print("Fetching weather data failed! Try refreshing again.")
            }
        }
        refreshControl.endRefreshing()
    }
}


extension WeatherInfoListView: UITableViewDataSource {
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
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        let iconName: String = weatherForecastInfo.weather.icon
        
        imageManager.fetchImage(of: iconName) { [weak self] image in
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                if indexPath == tableView.indexPath(for: cell) {
                    cell.weatherIcon.image = image
                }
            }
        }
        
        return cell
    }
}

extension WeatherInfoListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailVC = WeatherDetailVC()
        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        detailViewController.cityInfo = weatherJSON?.city
        detailViewController.tempUnit = tempUnit
//        navigationController?.show(detailViewController, sender: self)
    }
}
