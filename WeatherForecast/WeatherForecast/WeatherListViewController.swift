//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherListViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var weatherListDataSource: WeatherListTableDataSource?
    var weatherListDelegate: WeatherListTableDelegate?
    
    var weatherJSON: WeatherJSON? {
        willSet {
            setNavTitle(with: newValue?.city.name)
            setTableDataSource(with: newValue)
            setTableDelegate(with: newValue)
        }
    }
    var tempUnit: TempUnit = .metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherListViewController {
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
        tableView.dataSource = weatherListDataSource
        tableView.delegate = weatherListDelegate
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
    
    private func setNavTitle(with text: String?) {
        guard let text else {return}
        DispatchQueue.main.async {
            self.navigationItem.title = text
        }
    }
    
    private func setTableDataSource(with jsonData: WeatherJSON?) {
        guard let weathers = jsonData?.weatherForecast else {return}
        self.weatherListDataSource = WeatherListTableDataSource(weathers: weathers, tempUnit: tempUnit)
        tableView.dataSource = weatherListDataSource
    }
    
    private func setTableDelegate(with jsonData: WeatherJSON?) {
        guard let weathers = jsonData?.weatherForecast,
              let city = jsonData?.city else {return}
        self.weatherListDelegate = WeatherListTableDelegate(baseVC: self, weathers: weathers, city: city, tempUnit: tempUnit)
        tableView.delegate = weatherListDelegate
    }
}

extension WeatherListViewController {
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
    }
}
