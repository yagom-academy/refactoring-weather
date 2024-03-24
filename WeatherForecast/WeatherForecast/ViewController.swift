//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


final class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var weatherJSON: WeatherJSON?
    private var icons: [UIImage]?
    private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    private var tempUnit: TempUnit = .metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

fileprivate enum WeatherTitleType: String {
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
                          
        let weather = weatherForecastInfo.weather
        
        weatherTableCell(cell: cell, indexPath: indexPath,iconName: weather.icon, imageView: cell.weatherIcon)
                
        cell.configure(weatherIcon: cell.weatherIcon, dateLabel: dataTimeIntervalSince1970(weatherForecastInfo.dt), temperatureLabel: "\(weatherForecastInfo.main.temp)\(tempUnit.expression)", weatherLabel: weather.main, descriptionLabel: weather.description)

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
extension ViewController {
    private func dataTimeIntervalSince1970(_ dt: TimeInterval) -> String {
        let date: Date = Date(timeIntervalSince1970: dt)
        return Utils.dateSetUp(DataCase.long).string(from: date)
    }
}

extension ViewController {
    private func weatherTableCell(cell: WeatherTableViewCell, indexPath: IndexPath, iconName: String, imageView: UIImageView) {
        let urlString: String = "\(ImageURLType.path.rawValue)\(iconName)\(ImageURLType.png.rawValue)"

      
            setImageChache(chache: imageChache, cell: cell, urlString: urlString)
        
        
            setImageTask(table: tableView, index: indexPath, cell: cell, urlString: urlString)
                
    }
    
    private func setImageChache(chache: NSCache<NSString, UIImage>, cell: WeatherTableViewCell, urlString: String) {
        if let image = chache.object(forKey: urlString as NSString) {
            cell.weatherIcon.image = image
            return
        }
    }
    
    private func setImageTask(table: UITableView, index: IndexPath, cell: WeatherTableViewCell, urlString: String) {
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            setObjectImageChache(chache: imageChache, image: image, urlString: urlString)
        
            setWeatherIconImage(table: tableView, index: index, cell: cell, image: image)
       
        }
    }
    
    private func setObjectImageChache(chache: NSCache<NSString, UIImage>, image: UIImage, urlString: String) {
        chache.setObject(image, forKey: urlString as NSString)
    }
    
    private func setWeatherIconImage(table: UITableView, index: IndexPath, cell: WeatherTableViewCell, image: UIImage) {
        guard index == table.indexPath(for: cell) else { return }
        cell.weatherIcon.image = image
    }
    
}

