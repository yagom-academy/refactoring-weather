//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  struct Dependency {
    let weatherDetailViewControllerFactory: (WeatherDetailViewController.Dependency) -> WeatherDetailViewController
    let defaultDateFormatter: DateFormatterContextService
    let sunsetDateFormatter: DateFormatterContextService
    let weatherRepository: WeatherRepositoryService
    let imageProvider: ImageProviderService
    let tempUnitManager: TempUnitManagerService
  }
  
  private let dependency: Dependency
  private var weatherJSON: WeatherJSON?
  
  private lazy var tableView: UITableView = WeatherTableView(
    delegate: self,
    dataSource: self
  )
  
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
    bind()
    initialSetUp()
  }
}

extension ViewController {
  @objc private func changeTempUnit() {
    dependency.tempUnitManager.update()
  }
  
  private func refresh() {
    Task {
      let fetchResult = await fetchWeather()
      switch fetchResult {
      case .success(let weatherJSON):
        self.weatherJSON = weatherJSON
        tableView.reloadData()
        navigationItem.title = weatherJSON.city.name
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func bind() {
    dependency
      .tempUnitManager
      .subscribe { [weak self] tempUnit in
        guard let self = self else { return }
        self.navigationItem.rightBarButtonItem?.title = tempUnit.character
        self.refresh()
      }
  }
  
  private func initialSetUp() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: dependency.tempUnitManager.currentValue.character,
      image: nil,
      target: self,
      action: #selector(changeTempUnit)
    )
    
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
  private func fetchWeather() async -> Result<WeatherJSON, Error> {
    return await dependency.weatherRepository.load()
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
    let cell: UITableViewCell = tableView.dequeueReusableCell(
      withIdentifier: "WeatherCell",
      for: indexPath
    )
    
    guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
          let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.item] else {
      return cell
    }
    
    let weatherTableViewCellModel = WeatherTableViewCellModel(
      from: weatherForecastInfo,
      dependency: .init(
        defaultDataFormatter: dependency.defaultDateFormatter,
        tempUnitManager: dependency.tempUnitManager
      )
    )
    cell.bind(weatherTableViewCellModel)
    
    return cell
  }
}

extension ViewController: UITableViewDelegateWithRefresh {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(
      at: indexPath,
      animated: true
    )

    guard let weatherJSON = weatherJSON else { return }
    
    let weatherDetailViewControllerModel: WeatherDetailViewControllerModel = .init(
      from: weatherJSON.weatherForecast[indexPath.item],
      weatherJSON.city,
      dependency: .init(
        defaultDateFormatter: dependency.defaultDateFormatter,
        sunsetDateFormatter: dependency.sunsetDateFormatter,
        tempUnitManager: dependency.tempUnitManager
      )
    )
    
    let weatherDetailViewControllerDependency: WeatherDetailViewController.Dependency = .init(
      weatherDetailViewControllerModel: weatherDetailViewControllerModel,
      imageProvider: dependency.imageProvider
    )
    
    let weatherDetailViewController = dependency.weatherDetailViewControllerFactory(weatherDetailViewControllerDependency)
    navigationController?.show(weatherDetailViewController, sender: self)
  }
  
  func tableView(_ tableView: UITableView, refresh: Void) {
    self.refresh()
  }
}
