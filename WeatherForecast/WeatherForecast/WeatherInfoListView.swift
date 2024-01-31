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
    private var imageManager: ImageManagerProtocol
    private var weatherJSON: WeatherJSON?
    private var tempUnit: TemperatureUnit = .metric
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    weak var delegate: WeatherInfoListViewProtocol?
    
    // MARK: - Init
    init(delegate: WeatherInfoListViewProtocol, fetchDataManager: FetchDataManagerProtocol, imageManager: ImageManagerProtocol) {
        self.delegate = delegate
        self.fetchDataManager = fetchDataManager
        self.imageManager = imageManager
        super.init(frame: .zero)
        layoutTableView()
        setUpTableView()
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
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Methods
    func changeTempUnit(to tempUnit: TemperatureUnit) {
        self.tempUnit = tempUnit
    }
    
    @objc func refresh() {
        fetchDataManager.fetchWeatherJSON { [weak self] weatherJSON in
            if let data = weatherJSON {
                self?.weatherJSON = data
                self?.tableView.reloadData()
                self?.delegate?.fetchCityName(data.city.name)
            } else {
                print("Fetching weather data failed! Try refreshing again.")
            }
        }
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource method
extension WeatherInfoListView: UITableViewDataSource {
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
        
        let iconName: String = weatherForecastInfo.weather.icon
        var weatherImage: UIImage?
        
        imageManager.fetchImage(of: iconName) { image in
            weatherImage = image
        }
        
        DispatchQueue.main.async {
            cell.updateCellUI(with: weatherForecastInfo, image: weatherImage, tempUnit: self.tempUnit)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate method
extension WeatherInfoListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherJSON = weatherJSON else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailVC = WeatherDetailVC(weatherForecastInfo: weatherJSON.weatherForecast[indexPath.row],
                                                                    cityInfo: weatherJSON.city,
                                                                    tempUnit: tempUnit)
        
        delegate?.fetchWeatherDetailVC(detailViewController)
    }
}
