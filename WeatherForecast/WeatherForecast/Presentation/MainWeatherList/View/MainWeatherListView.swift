//
//  MainWeatherListView.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/02.
//

import UIKit

protocol MainWeatherListViewDelete: AnyObject {
    func showWeatherDetailInfo(detailVC: WeatherDetailViewController)
    func changeNavigationTitle(title: String?)
}

final class MainWeatherListView: UIView {
    // MARK: - Properties
    struct Dependency {
        let weatherDetailViewControllerFactory: (WeatherDetailViewController.Dependency) -> WeatherDetailViewController
        let weatherDetailViewFactory: (WeatherDetailView.Dependency) -> WeatherDetailView
        let weatherJsonService: JsonService
        let imageService: NetworkService
        let tempUnitManager: TempUnitManagerService
    }
    
    private let dependency: Dependency
    private var weatherJSON: WeatherJSON?
    
    var delegate: MainWeatherListViewDelete?

    // MARK: - UI
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(
        dependency: Dependency
    ) {
        self.dependency = dependency
        super.init(frame: .zero)
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func initialSetUp() {
        backgroundColor = .white

        setTableView()
    }
    
    private func setTableView() {
        layoutView()
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
    }
    
    private func layoutView() {
        
        tableView = .init(frame: .zero, style: .plain)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func refresh() {
        Task {
            let fetchResult = await self.fetchWeather()
            switch fetchResult {
            case .success(let featchData):
                self.weatherJSON = featchData
                tableView.reloadData()
                delegate?.changeNavigationTitle(title: featchData.city.name)
            case .failure(let error):
                print(error)
            }
        }
       
        refreshControl.endRefreshing()
    }
    
    private func fetchWeather() async -> Result<WeatherJSON, JsonError> {
        return await dependency.weatherJsonService.fetchWeather()
    }
}

extension MainWeatherListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: WeatherTableViewCell.identifier,
            for: indexPath
        )
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForcast = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
    
        cell.configureCell(weatherInfo: weatherForcast,
                           tempUnitManager: dependency.tempUnitManager,
                           imageService: dependency.imageService
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let weatherDetailVC = createWeatherDetailViewController(indexPath: indexPath)
        
        delegate?.showWeatherDetailInfo(detailVC: weatherDetailVC as! WeatherDetailViewController)
    }
}

extension MainWeatherListView {
    private func createWeatherDetailViewController(indexPath: IndexPath) -> UIViewController {
        guard let weatherJSON = weatherJSON else { return UIViewController() }
        
        let weatherDetailInfo = createWeatherDetailInfo(
            weatherJSON: weatherJSON,
            indexPath: indexPath
        )
        
        let weatherDetailViewControllerDependency = createWeatherDetailViewControllerDependency(weatherDetaiInfo: weatherDetailInfo)
        
        let weatherDetailViewController = dependency.weatherDetailViewControllerFactory(weatherDetailViewControllerDependency)
        
        return weatherDetailViewController
    }
    
    private func createWeatherDetailInfo(
      weatherJSON: WeatherJSON,
      indexPath: IndexPath
    ) -> WeatherDetailInfo {
        let weatherDetailInfo: WeatherDetailInfo = .init(
            weatherForecastInfo: weatherJSON.weatherForecast[indexPath.item],
            cityInfo: weatherJSON.city,
            tempUnit: dependency.tempUnitManager.tempUnit
        )
      
      return weatherDetailInfo
    }
    
    private func createWeatherDetailViewControllerDependency(
        weatherDetaiInfo: WeatherDetailInfo
    ) -> WeatherDetailViewController.Dependency {
        let weatherDetailViewControllerDependency: WeatherDetailViewController.Dependency = .init(
            weatherDetailViewFactory: dependency.weatherDetailViewFactory,
            weatherDetailInfo: weatherDetaiInfo,
            imageService: dependency.imageService
        )
      
      return weatherDetailViewControllerDependency
    }
}
