//
//  WeatherForecast - WeatherListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {
  private let weatherFetcherService: WeatherFetcherServiceable
  private let weatherImageCacheService: WeatherImageCacheServiceable
  private var weatherJSON: WeatherJSON?
  private var tempUnit: TempUnit = .metric
  
  private let tableView: UITableView = .init(frame: .zero, style: .plain)
  
  init(
      weatherFetcherService: WeatherFetcherServiceable,
      weatherImageCacheService: WeatherImageCacheServiceable
  ) {
    self.weatherFetcherService = weatherFetcherService
    self.weatherImageCacheService = weatherImageCacheService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
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
        title: TempUnit.imperial.title,
        image: nil,
        target: self,
        action: #selector(changeTempUnit)
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
    tableView.register(
        WeatherTableViewCell.self,
        forCellReuseIdentifier: WeatherTableViewCell.identifier
    )
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  @objc private func changeTempUnit() {
    switch tempUnit {
    case .imperial:
      tempUnit = .metric
    case .metric:
      tempUnit = .imperial
    }
    navigationItem.rightBarButtonItem?.title = tempUnit.title
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
    let result = weatherFetcherService.execute()
    switch result {
    case .success(let weatherJson):
      onSuccessFetchWeather(weatherJson)
    case .failure(let error):
      onFailFetchWeather(error)
    }
  }
  
  private func onSuccessFetchWeather(_ weatherJson: WeatherJSON) {
    self.weatherJSON = weatherJson
    navigationItem.title = weatherJSON?.city.name
  }
  
  private func onFailFetchWeather(_ error: Error) {
    print("WeatherListViewController - onFail fetchWeather: \(error)")
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
    
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier: WeatherTableViewCell.identifier,
        for: indexPath
    ) as? WeatherTableViewCell else {
      return .init()
    }
    
    guard let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
      return cell
    }
    
    let weatherCellInfo = WeatherCellInfo(
        dt: weatherForecastInfo.dt,
        main: weatherForecastInfo.main,
        weather: weatherForecastInfo.weather,
        tempExpression: tempUnit.expression
    )
    
    Task {
      let iconName: String = weatherForecastInfo.weather.icon
      do {
        let image = try await weatherImageCacheService.execute(iconName: iconName)
        
        await MainActor.run {
          guard indexPath == tableView.indexPath(for: cell) else {
            return
          }
          cell.set(image: image)
        }
      } catch {
        print("WeatherListViewController - imageCacheService execute Error: \(error)")
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
      tempUnit: tempUnit
    )
    
    let detailViewController: WeatherDetailViewController = .init(
        weatherImageCacheService: weatherImageCacheService,
        weatherDetailInfo: detailInfo
    )
    
    navigationController?.show(detailViewController, sender: self)
  }
}
