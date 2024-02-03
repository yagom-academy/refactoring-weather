//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    // TODO: - lazy 로 설정해주는게 맞을지 확인 필요
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    var tempUnit: TempUnit = .metric // TODO: 이거 딴곳으로 옮겨야하는거 아니야?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨",
                                                            image: nil,
                                                            target: self,
                                                            action: #selector(changeTempUnit))
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        setupTableView()
    }
    
    // TODO: - 테이블뷰 관련 작업을 다양한 곳에서 처리하고 있어 이를 수정함
    private func setupTableView() {
        view.addSubview(tableView)
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
        
        cell.configure(weatherForecastInfo: weatherForecastInfo)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 파라미터를 그대로 던져주는게 가독성이 떨어지는 것 같아 수정. 이런것도 DI 라고 봐야하나?
        let weatherForecast = weatherJSON?.weatherForecast[indexPath.row]
        let cityInfo = weatherJSON?.city
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherForecastInfo: weatherForecast,
                                                                                            cityInfo: cityInfo,
                                                                                            tempUnit: tempUnit)
        navigationController?.show(detailViewController, sender: self)
    }
}


