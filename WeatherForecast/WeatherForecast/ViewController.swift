//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


class ViewController: UIViewController {
    
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    var tempUnit: TempUnit = .metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

enum WeatherTitleType: String {
    case celsius = "섭씨"
    case fahrenheit = "화씨"
}

extension ViewController {
    
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "\(WeatherTitleType.celsius.rawValue)"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "\(WeatherTitleType.fahrenheit.rawValue)"
        }
        refresh()
    }
    
    @objc private func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(WeatherTitleType.fahrenheit)", image: nil, target: self, action: #selector(changeTempUnit))
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
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

        weatherJSON = info
        navigationItem.title = weatherJSON?.city.name
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.delegate = self
                             
        WeatherTableCell(cell: cell, indexPath: indexPath,iconName: weatherForecastInfo.weather.icon, imageView: cell.weatherIcon)
                
        cell.configure(weatherIcon: cell.weatherIcon, dateLabel: dataTimeIntervalSince1970(weatherForecastInfo.dt), temperatureLabel: "\(weatherForecastInfo.main.temp)\(tempUnit.expression)", weatherLabel: weatherForecastInfo.weather.main, descriptionLabel: weatherForecastInfo.weather.description)

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        detailViewController.cityInfo = weatherJSON?.city
        detailViewController.tempUnit = tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}
extension ViewController : dateFomatterSetUp {
    private func dataTimeIntervalSince1970(_ dt: TimeInterval) -> String {
        let date: Date = Date(timeIntervalSince1970: dt)
        return dateSetUp(DataCase.long).string(from: date)
    }
    
    func dateSetUp(_ format: String?) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        let dateFormat = DateFormat(dataFormater: format, dateFormatStyle: .none)
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: dateFormat.locale)
        formatter.dateFormat = dateFormat.dataFormater

        guard format != nil else {
            formatter.dateFormat = .none
            return formatter
        }
        
        return formatter
    }

}

extension ViewController: WeatherTableDelegate {
    func WeatherTableCell(cell: WeatherTableViewCell, indexPath: IndexPath, iconName: String, imageView: UIImageView) {
        let urlString: String = "\(ImageURLType.path.rawValue)\(iconName)\(ImageURLType.png.rawValue)"

        if let image = imageChache.object(forKey: urlString as NSString) {
            cell.weatherIcon.image = image
            return
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageChache.setObject(image, forKey: urlString as NSString)

            if indexPath == tableView.indexPath(for: cell) {
                cell.weatherIcon.image = image
            }
        }
    }
    
}

