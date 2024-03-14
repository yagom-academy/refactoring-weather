//
//  WeatherListView.swift
//  WeatherForecast
//
//  Created by Choi Oliver on 3/13/24.
//

import UIKit

protocol WeatherListViewDelegate: UITableViewDelegate, UITableViewDataSource {
    func weatherSelected(_ weather: WeatherForecastInfo)
    func refresh()
}

class WeatherListView: UIView {
    
    // MARK: UI
    private let tableView: UITableView = {
        let tableView: UITableView = .init()
        
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let control: UIRefreshControl = UIRefreshControl()
        
        return control
    }()
    
    private var delegate: WeatherListViewDelegate
    
    init(delegate: WeatherListViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        backgroundColor = .white
        
        setUpTableView()
        setUpRefreshControl()
    }
    
    private func setUpTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.ReuseIdentifier)
        tableView.dataSource = delegate
        tableView.delegate = delegate
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        delegate.refresh()
    }
    
    func updateUI() {
        tableView.reloadData()
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
