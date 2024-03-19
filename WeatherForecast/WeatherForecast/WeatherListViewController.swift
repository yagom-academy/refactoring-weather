//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol WeatherListTableViewProtocol {
    var weatherListDataSource: WeatherListTableDataSource { get }
    var weatherListDelegate: WeatherListTableDelegate { get }
}

struct WeatherListTableViewAdopter: WeatherListTableViewProtocol {
    let weatherListDataSource: WeatherListTableDataSource
    let weatherListDelegate: WeatherListTableDelegate
    
    init(weatherListDataSource: WeatherListTableDataSource, weatherListDelegate: WeatherListTableDelegate) {
        self.weatherListDataSource = weatherListDataSource
        self.weatherListDelegate = weatherListDelegate
    }
}

class WeatherListViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var tableViewAdopter: WeatherListTableViewProtocol?
    var weatherJSON: WeatherJSON? {
        willSet {
            setNavTitle(with: newValue?.city.name)
            setTableDataSourceAndDelegate(with: newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherListViewController {
    @objc private func changeTempUnit() {
        switch Shared.tempUnit {
        case .imperial:
            Shared.tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            Shared.tempUnit = .imperial
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
        tableView.dataSource = tableViewAdopter?.weatherListDataSource
        tableView.delegate = tableViewAdopter?.weatherListDelegate
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
    
    private func setTableDataSourceAndDelegate(with jsonData: WeatherJSON?) {
        guard let weathers = jsonData?.weatherForecast,
              let city = jsonData?.city else {return}
        
        let weatherListDataSource = WeatherListTableDataSource(weathers: weathers)
        let weatherListDelegate = WeatherListTableDelegate(baseVC: self, weathers: weathers, city: city)
        
        tableViewAdopter = WeatherListTableViewAdopter(weatherListDataSource: weatherListDataSource, weatherListDelegate: weatherListDelegate)
        tableView.dataSource = weatherListDataSource
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
