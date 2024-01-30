//
//  WeatherListView.swift
//  WeatherForecast
//
//  Created by 김창규 on 1/30/24.
//

import UIKit

protocol WeatherListViewDelegate: AnyObject {
    func selectWeatherItem(detailViewController: WeatherDetailViewController)
    func changeNavigationTitle(title: String?)
}

final class WeatherListView: UIView {
    //MARK: - Properties
    var delegate: WeatherListViewDelegate?
    var weatherInfo: WeatherInfoCoordinator
    var imageService: ImageServiceable
    var jsonService: JsonServiceable
    
    //MARK: - UI
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Init
    init(weatherInfo: WeatherInfoCoordinator,
         imageService: ImageServiceable,
         jsonService: JsonServiceable) {
        print("WeatherListView - init()")
        self.weatherInfo = weatherInfo
        self.imageService = imageService
        self.jsonService = jsonService
        
        super.init(frame: .zero)
        layoutView()
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    private func layoutView() {
        backgroundColor = .white
        tableView = .init(frame: .zero, style: .plain)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
    }
    
    @objc func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func fetchWeatherJSON() {
        guard let info = jsonService.fetchWeatherJSON() else  {
            return
        }
        
        weatherInfo.setWeatherJSON(json: info)
        delegate?.changeNavigationTitle(title: weatherInfo.getCityInfo()?.name)
    }
    
    func setTempUnit(type: TempUnit) {
        weatherInfo.tempUnit = type
    }
}

extension WeatherListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherInfo.weatherForecastInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherInfo.getWeatherForecastInfo(at: indexPath.row) else {
            return cell
        }
        
        imageService.getIcon(iconName: weatherForecastInfo.getIconName()) { image in
            DispatchQueue.main.async {
                cell.configure(weatherInfo: self.weatherInfo,image: image, index: indexPath.row)
             }
        }
        
        return cell
    }
}

extension WeatherListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let weatherForecastInfo = weatherInfo.getWeatherForecastInfo(at: indexPath.row),
              let city = weatherInfo.getCityInfo() else { return }
                
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(
            weatherDetailInfo: WeatherDetailInfo(
                weatherForecastInfo: weatherForecastInfo,
                cityInfo: city,
                tempUnit: weatherInfo.tempUnit
            )
        )
        
        delegate?.selectWeatherItem(detailViewController: detailViewController)
    }
}
