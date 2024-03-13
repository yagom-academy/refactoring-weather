//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherViewController: UIViewController {
    private let tableView: UITableView = .init(frame: .zero, style: .plain)
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var weatherJSON: WeatherJSON?
    private var tempUnit: TempUnit
    
    private let weatherService: WeatherJSONService
    private let imageService: WeatherImageService

    init(tempUnit: TempUnit,
        weatherService: WeatherJSONService,
        imageService: WeatherImageService) {
        self.tempUnit = tempUnit
        self.weatherService = weatherService
        self.imageService = imageService
        
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
        
        weatherService.fetchWeather { [weak self] weatherJSON in
            guard let self = self else { return }
            
            self.weatherJSON = weatherJSON
            navigationItem.title = weatherJSON.city.name
        }
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        tempUnit.toggle()
        refresh()
    }
    
    @objc private func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        navigationItem.title = weatherJSON?.city.name
    }
    
    private func initialSetUp() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: tempUnit.description, 
                                                            image: nil,
                                                            target: self,
                                                            action: #selector(changeTempUnit))
        navigationItem.title = weatherJSON?.city.name
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, 
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
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
        return weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
    
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        let iconName: String = weatherForecastInfo.weather.icon
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.symbol)"
        cell.dateLabel.text = DateFormatter.convertToKorean(by: date)

        imageService.fetchImage(iconName: iconName) { image in
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
        
        let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        let city = weatherJSON?.city
        let weatherDetailInfo = WeatherDetailInfo(weatherForecastInfo: weatherForecastInfo, 
                                                  cityInfo: city,
                                                  tempUnit: tempUnit)
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherDetailInfo: weatherDetailInfo, 
                                                                                            imageService: imageService)
        
        navigationController?.show(detailViewController, sender: self)
    }
}


