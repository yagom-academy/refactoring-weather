//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine


final class WeatherListViewController: UIViewController {
    
    private var viewModel: WeatherListViewModel
    private let input = PassthroughSubject<WeatherListViewModel.Input, Never>()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: String("\(WeatherTableViewCell.self)"))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: WeatherListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.viewWillAppear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        setConstraints()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .sink { [weak self] event in
                guard let self else { return }
                
                refreshUI()
            }
            .store(in: &viewModel.cancellable)
    }
}

extension WeatherListViewController {
    private func makeUI() {
        let currentUnit = viewModel.tempUnit
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: currentUnit.title,
            image: nil,
            target: self,
            action: #selector(changeTempUnit)
        )
        
        refreshControl.addTarget(
            self,
            action: #selector(setPullToRefresh),
            for: .valueChanged
        )
    }
    
    private func setConstraints() {
        view.addSubview(tableView)
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc
    private func changeTempUnit() {
        let updateUnit: TempUnit = viewModel.tempUnit == .metric ? .imperial: .metric
        input.send(.updateTempUnit(updateUnit))
    }
    
    @objc
    private func setPullToRefresh() {
        input.send(.setRefreshWithTableView)
    }
    
    private func refreshUI() {
        let weatherInfo = viewModel.weatherInfo
        let city = weatherInfo?.city
        navigationItem.title = city?.name
        
        let updatedUnit = viewModel.tempUnit
        navigationItem.rightBarButtonItem?.title = updatedUnit.title
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherInfo = viewModel.weatherInfo else {
            return .zero
        }
        
        let weatherList = weatherInfo.weatherForecast
        
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: String("\(WeatherTableViewCell.self)"), for: indexPath)
        
        guard 
            let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
            let weatherInfo = viewModel.weatherInfo,
            let weatherForecastInfo = weatherInfo.weatherForecast[safe: indexPath.row]
        else {
            return cell
        }
        
        cell.configure(
            with: weatherForecastInfo,
            tempUnit: viewModel.tempUnit
        )
        
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let weatherInfo = viewModel.weatherInfo,
            let weatherForecastInfo = weatherInfo.weatherForecast[safe: indexPath.row]
        else {
            return
        }
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        detailViewController.weatherForecastInfo = weatherForecastInfo
        detailViewController.cityInfo = weatherInfo.city
        detailViewController.tempUnit = viewModel.tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}
