//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    var tableView: UITableView!
    let imageCache: ImageCache = ImageCache()
    var model: WeatherForecastModel!
    var tempUnit: TempUnit = .celsius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = WeatherForecastModel()
        initialSetUp()
    }
}

extension ViewController {
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
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
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
}

extension ViewController {
    private func requestWeatherJSON() {
        navigationItem.title = model.getCityName()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.getWeatherForecastCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell else {
            return cell
        }
        
        let weatherForecastInfo = model.getWeatherForecast()[indexPath.row]
        
        cell.setData(weatherForecastInfo, unit: tempUnit)
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
    
        cell.dateLabel.text = dateFormatter.string(from: date)
                
        let iconName: String = weatherForecastInfo.weather.icon         
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
                
        if let image = imageCache[urlString] {
            cell.weatherIcon.image = image
            return cell
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageCache[urlString] = image
            
            if indexPath == tableView.indexPath(for: cell) {
                cell.weatherIcon.image = image
            }
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        let weatherInfo = model.getWeatherForecast()[indexPath.row]
        
        detailViewController.weatherForecastInfo = weatherInfo
        detailViewController.cityInfo = model.getCity()
        detailViewController.tempUnit = tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}


