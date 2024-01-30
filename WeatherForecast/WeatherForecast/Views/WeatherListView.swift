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
    
    //MARK: - UI
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    
    //MARK: - Init
    init(weatherInfo: WeatherInfoCoordinator,
         imageService: ImageServiceable) {
        self.weatherInfo = weatherInfo
        self.imageService = imageService
        super.init(frame: .zero)
        layoutView()
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
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
    
    @objc func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
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
        
        weatherInfo.setWeatherJSON(json: info)
        delegate?.changeNavigationTitle(title: weatherInfo.getCityInfo()?.name)
    }
    
    func setTempUnit(type: TempUnit) {
        weatherInfo.tempUnit = type
    }
}

extension WeatherListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherInfo.weatherForecastInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherInfo.getWeatherForecastInfo(at: indexPath.row),
              let weatherForecastTemp = weatherInfo.getTemp(at: indexPath.row) else {
            return cell
        }
        
        cell.weatherLabel.text      = weatherForecastInfo.getWeather()
        cell.descriptionLabel.text  = weatherForecastInfo.getDescription()
        cell.temperatureLabel.text  = weatherForecastTemp
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        imageService.getIcon(iconName: weatherForecastInfo.getIconName()) { image in
            DispatchQueue.main.async {
                cell.weatherIcon.image = image
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
