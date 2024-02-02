//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherForecastViewController: UIViewController {
    private var tableView: UITableView!
    private let imageCache: ImageCache = ImageCache()
    private var model: WeatherForecastModel!
    private var tempUnit: TempUnit = .celsius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = WeatherForecastModel()
        initialSetUp()
    }
}

extension WeatherForecastViewController {
    @objc private func changeTempUnit() {
        tempUnit.toggle()
        navigationItem.rightBarButtonItem?.title = tempUnit.title
        refresh()
    }
    
    @objc private func refresh() {
        requestWeatherJSON()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        layTable()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.reuseIdentifier)
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
    
    private func fetchImage(urlString: String) async -> UIImage? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

extension WeatherForecastViewController {
    private func requestWeatherJSON() {
        navigationItem.title = model.cityName
    }
}

extension WeatherForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.weatherForecastCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell else {
            return cell
        }
        
        let weatherForecastInfo = model.weatherForecast[indexPath.row]
        
        cell.setData(weatherForecastInfo, unit: tempUnit)
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        
        cell.setDateLabel(with: date.toString())
        
                
        let iconName: String = weatherForecastInfo.weather.icon         
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
                
        if let image = imageCache[urlString] {
            cell.setWeatherIcon(image: image)
            return cell
        }
        
        Task {
            if indexPath == tableView.indexPath(for: cell) {
                let image = await fetchImage(urlString: urlString)
                cell.setWeatherIcon(image: image)
            }
        }
        
        return cell
    }
}

extension WeatherForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let weatherInfo = model.weatherForecast[indexPath.row]
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(
            weatherForecastInfo: weatherInfo,
            cityInfo: model.city,
            tempUnit: tempUnit
        )
        
        navigationController?.show(detailViewController, sender: self)
    }
}


