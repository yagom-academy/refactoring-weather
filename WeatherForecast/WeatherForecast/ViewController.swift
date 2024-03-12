//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var tableView: UITableView!
  let refreshControl: UIRefreshControl = .init()
  var weatherJSON: WeatherJSON?
  var icons: [UIImage]?
  let imageChache: NSCache<NSString, UIImage> = .init()
  let dateFormatter: DateFormatter = {
    let formatter: DateFormatter = .init()
    formatter.locale = .init(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    return formatter
  }()
  
  var tempUnit: TempUnit = .metric
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
}

extension ViewController {
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
    fetchWeatherJSON()
    tableView.reloadData()
    refreshControl.endRefreshing()
  }
  
  private func initialSetUp() {
    navigationItem.rightBarButtonItem = .init(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
    
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

extension ViewController {
  private func fetchWeatherJSON() {
    
    let jsonDecoder: JSONDecoder = .init()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    guard let data = NSDataAsset(name: "weather")?.data else {
      return
    }
    
    let info: WeatherJSON
    do {
      info = try jsonDecoder.decode(WeatherJSON.self, from: data)
    } catch {
      print(error.localizedDescription)
      return
    }
    
    weatherJSON = info
    navigationItem.title = weatherJSON?.city.name
  }
}

extension ViewController: UITableViewDataSource {
  
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
    
    let date: Date = .init(timeIntervalSince1970: weatherForecastInfo.dt)
    cell.dateLabel.text = dateFormatter.string(from: date)
    
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

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let detailViewController: WeatherDetailViewController = .init()
    detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
    detailViewController.cityInfo = weatherJSON?.city
    detailViewController.tempUnit = tempUnit
    navigationController?.show(detailViewController, sender: self)
  }
}


