//
//  WeatherInfoListView.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

protocol WeatherInfoListViewProtocol: AnyObject {
    func fetchCityName(_ cityName: String)
    func fetchWeatherDetailVC(_ detailVC: WeatherDetailVC)
}

final class WeatherInfoListView: UIView {

    // MARK: - Properties
    private var fetchDataManager: FetchDataManagerProtocol
    private var weatherInfo: WeatherInfoProtocol?
    private var tempUnit: TemperatureUnit
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    weak var delegate: WeatherInfoListViewProtocol?
    
    // MARK: - UI
    private var tableView: UITableView!
    private var weatherInfoListDataSource: WeatherInfoListDataSource!
    
    // MARK: - Init
    init(delegate: WeatherInfoListViewProtocol, fetchDataManager: FetchDataManagerProtocol, tempUnit: TemperatureUnit) {
        self.delegate = delegate
        self.fetchDataManager = fetchDataManager
        self.tempUnit = tempUnit
        super.init(frame: .zero)
        layoutTableView()
        setUpTableView()
        setUpTableViewDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func layoutTableView() {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        tableView = .init(frame: .zero, style: .plain)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setUpTableView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.cellId)
        tableView.delegate = self
    }
    
    private func setUpTableViewDataSource() {
        weatherInfoListDataSource = .init(weatherInfo: weatherInfo,
                                          imageManager: ImageManager())
        tableView.dataSource = weatherInfoListDataSource
    }
    
    // MARK: - Methods
    func changeTempUnit(to tempUnit: TemperatureUnit) {
        self.tempUnit = tempUnit
    }
    
    @objc func refresh() {
        Task {
            let fetchedData = await fetchDataManager.fetchWeatherData()
            if let data = fetchedData {
                weatherInfo = WeatherInfo(weatherForecast: data.weatherForecast,
                                          city: CityInfo(city: data.city),
                                          temperatureUnit: self.tempUnit)
                weatherInfoListDataSource.updateWeatherData(with: weatherInfo)
                tableView.reloadData()
                delegate?.fetchCityName(data.city.name)
            } else {
                print("Fetching weather data failed! Try refreshing again.")
            }
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate method
extension WeatherInfoListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherInfo = weatherInfo else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailVC = WeatherDetailVC(
            weatherForecastInfo: weatherInfo.fetchWeatherForecastItem(at: indexPath.item),
            cityInfo: weatherInfo.city)
        
        delegate?.fetchWeatherDetailVC(detailViewController)
    }
}
