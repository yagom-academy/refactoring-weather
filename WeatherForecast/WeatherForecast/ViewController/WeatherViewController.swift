//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    private var viewModel: WeatherViewModelProtocol
    private var temperatureConverter: TemperatureConverterProtocol
    let refreshControl: UIRefreshControl
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(viewModel: WeatherViewModelProtocol,
         temperatureConverter: TemperatureConverterProtocol,
         refreshControl: UIRefreshControl) {
        self.viewModel = viewModel
        self.temperatureConverter = temperatureConverter
        self.refreshControl = refreshControl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setup()
    }
    
    private func bind() {
        Task {
            await viewModel.fetchWeatherData()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension WeatherViewController {
    private func setup() {
        navigationItem.title = viewModel.cityName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: UI.imperial,
                                                            image: nil,
                                                            target: self,
                                                            action: #selector(changeTempUnit))
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        setupTableView()
    }
    
    @objc private func changeTempUnit() {
        navigationItem.rightBarButtonItem?.title = temperatureConverter.toggleTemperature()
        refresh()
    }
    
    @objc private func refresh() {
        Task {
            await viewModel.fetchWeatherData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = viewModel.weatherForecast?[indexPath.row] else {
            return cell
        }
        
        cell.configure(weatherForecastInfo: weatherForecastInfo)
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let weatherForecast = viewModel.weatherForecast?[indexPath.row]
        let cityInfo = viewModel.city
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherForecastInfo: weatherForecast,
                                                                                            cityInfo: cityInfo,
                                                                                            tempUnit: temperatureConverter.tempUnit)
        navigationController?.show(detailViewController, sender: self)
    }
}
