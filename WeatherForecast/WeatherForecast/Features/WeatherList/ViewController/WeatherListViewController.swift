//
//  WeatherForecast - WeatherListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {
  private let weatherUseCase: WeatherUseCase
  private var weatherJSON: WeatherJSON?
  private var temperatureUnit: TemperatureUnit = .celsius
  
  private let tableView: UITableView = .init(frame: .zero, style: .plain)
  
  init(weatherUseCase: WeatherUseCase) {
    self.weatherUseCase = weatherUseCase
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
    onRefresh()
  }
}

extension WeatherListViewController {
  private func initialSetUp() {
    setUpView()
    setUpNavigationItem()
    setLayout()
    setUpTableView()
  }
  
  private func setUpView() {
    view.backgroundColor = .white
  }
  
  private func setUpNavigationItem() {
    navigationItem.rightBarButtonItem = .init(
        title: TemperatureUnit.fahrenheit.strategy.title,
        image: nil,
        target: self,
        action: #selector(toggleTemperatureUnitButtonTapped)
    )
  }
  
  private func setLayout() {
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
  
  private func setUpTableView() {
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(
        self,
        action: #selector(onRefresh),
        for: .valueChanged
    )
    
    tableView.register(WeatherTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  @objc private func toggleTemperatureUnitButtonTapped() {
    temperatureUnit.toggle()
    navigationItem.rightBarButtonItem?.title = temperatureUnit.strategy.title
    onRefresh()
  }
  
  @objc private func onRefresh() {
    fetchWeatherJSON()
    refreshTableView()
  }
  
  private func refreshTableView() {
    tableView.reloadData()
    tableView.refreshControl?.endRefreshing()
  }
}

extension WeatherListViewController {
  private func fetchWeatherJSON() {
    guard let weatherJSON = weatherUseCase.fetchWeather() else {
      return
    }
    self.weatherJSON = weatherJSON
    navigationItem.title = weatherJSON.city.name
  }
}

extension WeatherListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = weatherJSON?.weatherForecast.count else {
      return 0
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: WeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
    guard let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
      return cell
    }
    
    let weatherCellInfo = weatherForecastInfo.toCellInfo(temperatureUnit: temperatureUnit)
    
    Task {
      let iconName: String = weatherForecastInfo.weather.icon
      guard let image = await weatherUseCase.fetchImage(from: iconName) else {
        return
      }
      
      await MainActor.run {
        guard indexPath == tableView.indexPath(for: cell) else {
          return
        }
        cell.set(image: image)
      }
    }
  
    cell.configure(weatherCellInfo: weatherCellInfo)
    
    return cell
  }
}

extension WeatherListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let detailInfo: WeatherDetailInfo = .init(
        weatherForecastInfo: weatherJSON?.weatherForecast[indexPath.row],
        cityInfo: weatherJSON?.city,
        temperatureUnit: temperatureUnit
    )
    
    let detailViewController: WeatherDetailViewController = .init(
        weatherListUseCase: weatherUseCase,
        weatherDetailInfo: detailInfo
    )
    
    navigationController?.show(detailViewController, sender: self)
  }
}

fileprivate extension WeatherForecastInfo {
  func toCellInfo(temperatureUnit: TemperatureUnit) -> WeatherCellInfo {
    return .init(
      dateTime: dateTime,
      main: main,
      weather: weather,
      temperatureUnitStrategy: temperatureUnit.strategy
    )
  }
}
