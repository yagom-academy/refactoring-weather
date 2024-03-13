//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherViewController: UIViewController {
    var tableView: UITableView = .init(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private let viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch()
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        viewModel.changeTempUnit()
        refresh()
    }
    
    @objc private func refresh() {
        viewModel.fetch()
        tableView.reloadData()
        refreshControl.endRefreshing()
        navigationItem.rightBarButtonItem?.title = viewModel.navigationBarItemTitle
        navigationItem.title = viewModel.city.name
    }
    
    private func initialSetUp() {
        view.backgroundColor = .systemBackground
        
        let tempUnit = viewModel.tempUnit
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: tempUnit.description, image: nil, target: self, action: #selector(changeTempUnit))
        navigationItem.title = viewModel.city.name
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func layTable() {
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

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell else {
            return cell
        }
        
        let weatherForecastInfo = viewModel.weatherForecast[indexPath.row]
        let tempUnit = viewModel.tempUnit
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        let iconName: String = weatherForecastInfo.weather.icon
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.symbol)"
        cell.dateLabel.text = DateFormatter.convertToKorean(by: date)

        viewModel.fetchImage(iconName: iconName) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                cell.weatherIcon.image = image
            }
        }
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let weatherForecastInfo = viewModel.weatherForecast[indexPath.row]
        let city = viewModel.city
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        detailViewController.weatherForecastInfo = weatherForecastInfo
        detailViewController.cityInfo = city
        detailViewController.tempUnit = viewModel.tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}


