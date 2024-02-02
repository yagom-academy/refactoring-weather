//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
 private lazy var tableView: UITableView = WeatherTableView(
  delegate: self,
  dataSource: self
 )
  
  var weatherJSON: WeatherJSON?
  var icons: [UIImage]?
  
  var tempUnit: TempUnit = .metric
  
  struct Dependency {
    let weatherDetailViewControllerFactory: (WeatherDetailViewController.Dependency) -> WeatherDetailViewController
    let defaultDateFormatter: DateFormatterContextService
    let sunsetDateFormatter: DateFormatterContextService
    let jsonDecoder: JSONDecodeHelperProtocol
    let imageProvider: ImageProviderService
  }
  
  private let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    
    private func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        layTable()
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

extension ViewController {
    private func fetchWeatherJSON() {
      
      guard let data = NSDataAsset(name: "weather")?.data else {
        return
      }
      
      let info: WeatherJSON
      
      let result = dependency.jsonDecoder.decode(
        WeatherJSON.self,
        from: data
      )
      switch result {
      case .success(let data):
        info = data
      case .failure(let error):
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
        
      cell.dateLabel.text = dependency.defaultDateFormatter.string(from: weatherForecastInfo.dt)
                
        let iconName: String = weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
            
      Task {
        let image = await ImageProvider.shared.image(url: urlString)
        if indexPath == tableView.indexPath(for: cell) {
            cell.weatherIcon.image = image
        }
      }
        
        return cell
    }
}

extension ViewController: UITableViewDelegateWithRefresh {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let weatherDetailViewControllerDependency: WeatherDetailViewController.Dependency = .init(
      defaultDateFormatter: dependency.defaultDateFormatter,
      sunsetDateFormatter: dependency.sunsetDateFormatter,
      weatherForecastInfo: weatherJSON?.weatherForecast[indexPath.row],
      cityInfo: weatherJSON?.city,
      tempUnit: tempUnit
    )
    let weatherDetailViewController = dependency.weatherDetailViewControllerFactory(weatherDetailViewControllerDependency)
    navigationController?.show(weatherDetailViewController, sender: self)
  }
  
  func tableView(_ tableView: UITableView, refresh: Void) {
    fetchWeatherJSON()
    tableView.reloadData()
  }
}
