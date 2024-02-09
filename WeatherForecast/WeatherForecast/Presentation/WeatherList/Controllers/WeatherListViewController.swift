//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherListViewController: UIViewController {
    private let weatherListView: WeatherListView = WeatherListView()
    private let weatherUseCase: WeatherUseCase
    private var cityWeather: CityWeather? {
        didSet {
            navigationItem.title = cityWeather?.city.name
        }
    }
    private var tempUnit: TemperatureUnit = .metric {
        didSet {
            navigationItem.rightBarButtonItem?.title = tempUnit.strategy.unitExpression
            Task { await refresh() }
        }
    }
    
    init(useCase: WeatherUseCase) {
        self.weatherUseCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(useCase: DefaultWeatherUseCase())
    }
    
    required init?(coder: NSCoder) {
        self.weatherUseCase = DefaultWeatherUseCase()
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = weatherListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        Task { await refresh() }
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
    func refresh() async {
        guard let url: URL = Bundle.main.url(forResource: "weather", withExtension: "json") else { return }
        cityWeather = await weatherUseCase.fetchCityWeather(from: url)
        weatherListView.reloadTableView()
        weatherListView.endRefreshControlRefreshing()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeather?.weathers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id, for: indexPath)
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weather = cityWeather?.weathers[indexPath.row] else {
            return cell
        }
        
        cell.configure(with: weather, using: tempUnit)
        Task {
            await configureWeatherIcon(with: weather.condition.icon, to: cell)
        }
        
        return cell
    }
    
    private func configureWeatherIcon(with name: String, to cell: WeatherTableViewCell) async {
        Task {
            guard let imageURL: URL = URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png") else { return }
            guard let imageData = await weatherUseCase.fetchWeatherImage(from: imageURL),
            let image = UIImage(data: imageData.data) else { return }
            cell.configure(image: image)
        }
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailVC(with: cityWeather?.weathers[indexPath.row])
    }
    
    private func showDetailVC(with weather: Weather?) {
        guard let weather: Weather = weather,
              let city: City = cityWeather?.city else { return }
        let weatherDetailContext: WeatherDetailContext = WeatherDetailContext(weather: weather, city: city, tempUnit: tempUnit)
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(contenxt: weatherDetailContext)
        navigationController?.show(detailViewController, sender: self)
    }
}
