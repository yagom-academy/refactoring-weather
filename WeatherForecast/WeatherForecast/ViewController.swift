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
    let dataRequester: DataRequestable
    let jsonExtracter: any JsonExtractable
    
    var tempUnit: TempUnit = .metric
    
    init(dataRequester: DataRequestable = DataRequest(), jsonExtracter: any JsonExtractable = WeatherJsonExtracter()) {
        self.dataRequester = dataRequester
        self.jsonExtracter = jsonExtracter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension ViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "화씨"
        }
        refresh()
    }
    
    @objc private func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
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
        guard let result = weatherJsonExtractedResult() else { return }
        weatherJSON = result
        navigationItem.title = result.city.name
    }
    
    private func weatherJsonExtractedResult() -> WeatherJsonExtracter.Result? {
        guard let result = jsonExtracter.extract() as? WeatherJsonExtracter.Result else { return nil }
        return result
    }
    
    private func requestWeatherIconImageData(urlString: String) async -> Data? {
        do {
            let data = try await dataRequester.request(urlString: urlString)
            return data
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func dataToUIImage(data: Data?) -> UIImage? {
        if let data = data, let image: UIImage = UIImage(data: data) {
            return image
        }

        return nil
    }
    
    private func setImageCache(image: UIImage?, key: String) {
        if let image = image {
            imageChache.setObject(image, forKey: key as NSString)
        }
    }
    
    private func setWeatherIconImageInTableView(image: UIImage?, tableView: UITableView, cell: WeatherTableViewCell, indexPath: IndexPath) {
        if isCorrectIndexPath(indexPath: indexPath, tableView: tableView, cell: cell) {
            cell.weatherIcon.image = image
        }
    }
    
    private func imageFromCache(key: String) -> UIImage? {
        let image = imageChache.object(forKey: key as NSString)
        return image
    }
    
    private func processAfterWeatherIconImageRequest(urlString: String, indexPath: IndexPath, tableView: UITableView, cell: WeatherTableViewCell) {
        Task {
            let imageData: Data? = await requestWeatherIconImageData(urlString: urlString)
            let dataToImage: UIImage? = dataToUIImage(data: imageData)
            DispatchQueue.main.async {
                self.setImageCache(image: dataToImage, key: urlString)
                self.setWeatherIconImageInTableView(image: dataToImage, tableView: tableView, cell: cell, indexPath: indexPath)
            }
        }
    }
    
    private func isCorrectIndexPath(indexPath: IndexPath, tableView: UITableView, cell: UITableViewCell) -> Bool {
        return indexPath == tableView.indexPath(for: cell)
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
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = date.toString(format: WeatherDate.format)
                
        let iconName: String = weatherForecastInfo.weather.icon         
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        if let image = imageFromCache(key: urlString) {
            cell.weatherIcon.image = image
            return cell
        }
        
        processAfterWeatherIconImageRequest(urlString: urlString, indexPath: indexPath, tableView: tableView, cell: cell)
        
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
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

