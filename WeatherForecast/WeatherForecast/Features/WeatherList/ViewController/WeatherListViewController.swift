//
//  WeatherForecast - WeatherListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherListViewController: UIViewController {
  private let weatherFetcherService: WeatherFetcherServiceable
  private var weatherJSON: WeatherJSON?
  private var tempUnit: TempUnit = .metric
  private let imageChache: NSCache<NSString, UIImage> = .init()
  
  private let tableView: UITableView = .init(frame: .zero, style: .plain)
  
  init(weatherFetcherService: WeatherFetcherServiceable) {
    self.weatherFetcherService = weatherFetcherService
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
    tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
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
    print("onFail fetchWeather: \(error)")
  }
}

extension WeatherListViewController: UITableViewDataSource, DateFormattable {
  
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
    cell.dateLabel.text = dateFormat(from: weatherForecastInfo.dt, with: .KoreanLongForm)
    
    let iconName: String = weatherForecastInfo.weather.icon
    let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    
    if let image = imageChache.object(forKey: urlString as NSString) {
      cell.weatherIcon.image = image
      return cell
    }
    
    Task {
      guard let url: URL = .init(string: urlString),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let image: UIImage = .init(data: data) else {
        return
      }
      
      imageChache.setObject(image, forKey: urlString as NSString)
      
      if indexPath == tableView.indexPath(for: cell) {
        cell.weatherIcon.image = image
      }
    }
    
    return cell
  }
}

extension WeatherListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let detailViewController: WeatherDetailViewController = .init()
    detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
    detailViewController.cityInfo = weatherJSON?.city
    detailViewController.tempUnit = tempUnit
    navigationController?.show(detailViewController, sender: self)
  }
}
