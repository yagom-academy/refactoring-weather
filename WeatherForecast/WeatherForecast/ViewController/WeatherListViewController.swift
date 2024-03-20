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

final class WeatherListViewController: UIViewController {
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var tableViewAdopter: WeatherListTableViewProtocol?
    private var weatherJSON: WeatherJSON? {
        willSet {
            setNavTitle(with: newValue?.city.name)
            updateTable(with: newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setTableDataSourceAndDelegate()
    }
}

extension WeatherListViewController {
    @objc private func changeTempUnit() {
        Shared.tempUnit = Shared.tempUnit.toggle()
        navigationItem.rightBarButtonItem?.title = Shared.tempUnit.textKR

        refresh()
    }
    
    @objc private func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        layoutTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
    }
    
    private func layoutTable() {
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
    
    private func setTableDataSourceAndDelegate() {
        self.tableViewAdopter = WeatherListTableViewAdopter(weatherListDataSource: WeatherListTableDataSource(), weatherListDelegate: WeatherListTableDelegate(baseVC: self))
        tableView.dataSource = tableViewAdopter?.weatherListDataSource
        tableView.delegate = tableViewAdopter?.weatherListDelegate
    }
    
    private func updateTable(with jsonData: WeatherJSON?) {
        guard let weathers = jsonData?.weatherForecast,
                      let city = jsonData?.city else {return}
        
        tableViewAdopter?.weatherListDataSource.weathers = weathers
        tableViewAdopter?.weatherListDelegate.weathers = weathers
        tableViewAdopter?.weatherListDelegate.city = city
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension WeatherListViewController {
    private func fetchWeatherJSON() {
        guard let assetData = JSONFetcher.createData(from: "weather"),
              let info: WeatherJSON = JSONFetcher.decodeJSON(data: assetData) else {return}
        
        weatherJSON = info
    }
}
