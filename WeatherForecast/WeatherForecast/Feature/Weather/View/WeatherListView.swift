//
//  WeatherListView.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit

protocol WeatherListViewDelegate {
    func weatherListView(_ weatherListView: WeatherListView, didSelectRowAt indexPath: IndexPath)
    func refresh()
}

class WeatherListView: UIView {
    
    // MARK: UI
    private let tableView: UITableView = {
        let tableView: UITableView = .init()
        
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let control: UIRefreshControl = UIRefreshControl()
        
        return control
    }()
    
    // MARK: UI Model
    private var weatherForecast: [WeatherForecastInfo]?
    private var city: City?
    private var tempUnit: TempUnit?
    
    private var delegate: WeatherListViewDelegate
    
    init(delegate: WeatherListViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        setUpTableView()
        setUpRefreshControl()
    }
    
    private func setUpTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.ReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        delegate.refresh()
//        fetchWeatherJSON()
//        tableView.reloadData()
//        refreshControl.endRefreshing()
    }
    
    func updateUI(_ fetchResult: FetchWeatherResult, _ tempUnit: TempUnit) {
        self.weatherForecast = fetchResult.weatherForecast
        self.city = fetchResult.city
        self.tempUnit = tempUnit
        
        tableView.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension WeatherListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
//        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
//        detailViewController.cityInfo = weatherJSON?.city
//        detailViewController.tempUnit = tempUnit
//        navigationController?.show(detailViewController, sender: self)
    }
}

extension WeatherListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.ReuseIdentifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherForecast?[indexPath.row] else {
            return cell
        }
        
        cell.setImageFetcher(ImageFetcherImpl())
        cell.updateUI(
            weatherMain: weatherForecastInfo.mainString,
            weatherDescription: weatherForecastInfo.description,
            temperature: tempUnit?.convert(weatherForecastInfo.temperature) ?? "-",
            date: weatherForecastInfo.dateString,
            icon: weatherForecastInfo.iconUrlString
        )
        
        return cell
    }
}
