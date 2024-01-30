//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by ChangMin on 1/30/24.
//

import UIKit

protocol WeatherViewDelegate: AnyObject {
    func fetchWeatherJSON()
}

class WeatherView: UIView {
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    private weak var delegate: WeatherViewDelegate?
    
    init(delegate: WeatherViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupTableView()
        setupRefreshControl()
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView = .init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
    }
    
    func setupTableViewDataSource(with dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func setupTableViewDelegate(with delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
    }
    
    @objc private func refresh() {
        delegate?.fetchWeatherJSON()
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
