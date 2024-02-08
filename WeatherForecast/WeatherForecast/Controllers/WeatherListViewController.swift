//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherListViewController: UIViewController {
    private let weatherListView: WeatherListView = WeatherListView()
    private let weatherListUseCase: WeatherListUseCase
    private var cityWeather: CityWeather? {
        didSet {
            navigationItem.title = cityWeather?.city.name
        }
    }
    private var tempUnit: TemperatureUnit = .metric {
        didSet {
            navigationItem.rightBarButtonItem?.title = tempUnit.strategy.unitExpression
            refresh()
        }
    }
    
    init(useCase: WeatherListUseCase) {
        self.weatherListUseCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(useCase: DefaultWeatherListUseCase())
    }
    
    required init?(coder: NSCoder) {
        self.weatherListUseCase = DefaultWeatherListUseCase()
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = weatherListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension WeatherListViewController {
    private func configureUI() {
        configureNavigationItems()
        configureDelegate()
    }
    
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: tempUnit.strategy.unitExpression, image: nil, target: self, action: #selector(changeTempUnit))
    }
    
    @objc private func changeTempUnit() {
        tempUnit = tempUnit.change()
    }
    
    private func configureDelegate() {
        weatherListView.delegate = self
        weatherListView.setTableViewDelegate(self)
        weatherListView.setTableViewDataSource(self)
    }
}

extension WeatherListViewController: WeatherListViewDelegate {
    func refresh() {
        let url: URL? = Bundle.main.url(forResource: "weather", withExtension: "json")
        cityWeather = weatherListUseCase.fetchWeatherList(url: url)
        weatherListView.reloadTableView()
        weatherListView.endRefreshControlRefreshing()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityWeather?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id, for: indexPath)
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = cityWeather?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.configure(with: weatherForecastInfo, using: tempUnit)
        Task {
            await configureWeatherIcon(with: weatherForecastInfo.weather.icon, to: cell)
        }
        
        return cell
    }
    
    private func configureWeatherIcon(with name: String, to cell: WeatherTableViewCell) async {
        Task {
            let imageURLString: String = "https://openweathermap.org/img/wn/\(name)@2x.png"
            guard let imageData = await weatherListUseCase.fetchWeatherImage(url: imageURLString),
            let image = UIImage(data: imageData.data) else { return }
            cell.configure(image: image)
        }
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailVC(with: cityWeather?.weatherForecast[indexPath.row])
    }
    
    private func showDetailVC(with weatherForecastInfo: WeatherForecastInfo?) {
        guard let weatherForecastInfo: WeatherForecastInfo = weatherForecastInfo,
              let cityInfo: City = cityWeather?.city else { return }
        let weatehrDetailContext: WeatherDetailContext = WeatherDetailContext(weatherForecastInfo: weatherForecastInfo,
                                                                              cityInfo: cityInfo,
                                                                              tempUnit: tempUnit)
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(contenxt: weatehrDetailContext)
        navigationController?.show(detailViewController, sender: self)
    }
}
