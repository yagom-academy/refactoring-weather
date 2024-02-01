//
//  WeatherForecast - ViewController.swift -> WeatherListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherListViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let model: WeatherListViewModel
    
    init(
        dataRequester: DataRequestable = DataRequest(),
        jsonExtracter: any JsonFileExtractable = JsonFileExtracter<WeatherJSON>(fileName: "weather")
    ) {
        self.model = .init(dataRequester: dataRequester, jsonExtracter: jsonExtracter)
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

// MARK: - UI Funcs..

extension WeatherListViewController {

    @objc private func navigationRightBarButtonAction() {
        setNavigationBarRightTitle(model.tempUnit.expressStrategy.text)
        model.changeTempUnit()
        refresh()
    }
    
    @objc private func refresh() {
        processAfterWeatherJSONExtract()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(navigationRightBarButtonAction))
        
        layTable()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherListTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
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

// MARK: - Combined Funcs..

extension WeatherListViewController {
    private func processAfterWeatherJSONExtract() {
        guard let result = model.extractedWeatherJsonResult() else { return }
        model.setWeatherJson(result)
        setNavigationBarMiddleTitle(result.city.name)
    }
    
    private func processAfterWeatherIconImageRequest(urlString: String, indexPath: IndexPath, tableView: UITableView, cell: WeatherListTableViewCell) {
        Task {
            guard let imageData: Data = await model.weatherIconImageDataAfterRequest(urlString: urlString) else { return }
            let dataToImage: UIImage? = imageData.toUIImage()
            
            DispatchQueue.main.async {
                self.model.setImageDataCache(data: imageData, key: urlString)
                self.setWeatherIconImageInCell(image: dataToImage, tableView: tableView, cell: cell, indexPath: indexPath)
            }
        }
    }
}

// MARK: - Set Funcs..

extension WeatherListViewController {
    
    private func setWeatherIconImageInCell(image: UIImage?, tableView: UITableView, cell: WeatherListTableViewCell, indexPath: IndexPath) {
        
        func isCorrectIndexPath(indexPath: IndexPath, tableView: UITableView, cell: UITableViewCell) -> Bool {
            return indexPath == tableView.indexPath(for: cell)
        }
        
        if isCorrectIndexPath(indexPath: indexPath, tableView: tableView, cell: cell) {
            cell.weatherIcon.image = image
        }
    }
    
    /// Set Success -> True
    /// Set Fail -> False
    private func setWeatherIconImageInCellFromCache(cell: WeatherListTableViewCell, key: String) -> Bool {
        guard let data = model.dataFromImageDataCache(key: key) else { return false }
        let image: UIImage? = data.toUIImage()
        cell.weatherIcon.image = image
        
        return true
    }
    
    private func setCellLabelText(cell: WeatherListTableViewCell, weatherForecastInfo: WeatherForecastInfo) {
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(model.tempUnit.expressStrategy.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = date.toString(format: WeatherDate.format)
    }
    
    private func setNavigationBarMiddleTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func setNavigationBarRightTitle(_ title: String) {
        navigationItem.rightBarButtonItem?.title = title
    }
}


// MARK: - Table View Deletgate Funcs..

extension WeatherListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherListTableViewCell = cell as? WeatherListTableViewCell, 
                let weatherForecastInfo: WeatherForecastInfo = model.weatherForecastInfo(index: indexPath.row) else {
            return cell
        }
                        
        setCellLabelText(cell: cell, weatherForecastInfo: weatherForecastInfo)

        let urlString: String = model.urlStringForIconRequest(iconName: weatherForecastInfo.weather.icon)
        if setWeatherIconImageInCellFromCache(cell: cell, key: urlString) { return cell }
        processAfterWeatherIconImageRequest(urlString: urlString, indexPath: indexPath, tableView: tableView, cell: cell)
        
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherListDetailViewController = WeatherListDetailViewController()
        detailViewController.weatherForecastInfo = model.weatherJSON?.weatherForecast[indexPath.row]
        detailViewController.cityInfo = model.weatherJSON?.city
        detailViewController.tempUnit = model.tempUnit
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

