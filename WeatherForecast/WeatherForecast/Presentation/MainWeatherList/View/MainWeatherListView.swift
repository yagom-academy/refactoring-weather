//
//  MainWeatherListView.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import UIKit

protocol MainWeatherListViewDelete: AnyObject {
    func showWeatherDetailInfo(detailVC: WeatherDetailViewController)
    func changeNavigationTitle(title: String?)
}

final class MainWeatherListView: UIView {
    // MARK: - Properties
    var delegate: MainWeatherListViewDelete?
    private let weatherJsonService: JsonService
    private var weatherJSON: WeatherJSON?
    
    // MARK: - UI
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(weatherJsonService: JsonService) {
        self.weatherJsonService = weatherJsonService
        super.init(frame: .zero)
        layoutView()
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func initialSetUp() {
        backgroundColor = .systemBackground

        setTableView()
    }
    
    private func layoutView() {
        
        tableView = .init(frame: .zero, style: .plain)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
    }
    
    @objc func refresh() {
        fetchWeatherJSON()
        refreshControl.endRefreshing()
    }
    
    private func fetchWeatherJSON() {
        let resultFetchWeatherJSONData = weatherJsonService.fetchWeatherJSON()
        switch resultFetchWeatherJSONData {
        case .success(let data):
            weatherJSON = data
            delegate?.changeNavigationTitle(title: weatherJSON?.city.name)
            tableView.reloadData()
        case .failure(let error):
            print(error)
        }
    }
}

extension MainWeatherListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return WeatherTableViewCell()
        }
        
        guard indexPath.row < (weatherJSON?.weatherForecast.count ?? 0), let weatherForcast = weatherJSON?.weatherForecast[indexPath.row] else {
            return WeatherTableViewCell()
        }
        
        cell.configureCell(weatherInfo: weatherForcast,
                                 imageService: WeatherIconImageService())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < (weatherJSON?.weatherForecast.count ?? 0), let weatherForcast = weatherJSON?.weatherForecast[indexPath.row] else {
            return
        }
        
        let weatherDetailVC = WeatherDetailViewController(weatherForecastInfo: weatherForcast, tempUnit: .metric)
        
        delegate?.showWeatherDetailInfo(detailVC: weatherDetailVC)
    }
}
