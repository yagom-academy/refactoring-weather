//
//  WeatherListView.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/13/24.
//

import UIKit

protocol WeatherListViewDelegate: UITableViewDataSource, UITableViewDelegate {
    func refresh()
    func changeTempUnit() -> String
    var navigationItem: UINavigationItem { get }}

final class WeatherListView: UIView {
    private var delegate: WeatherListViewDelegate?
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        WeatherTableViewCell.registerClass(superView: tableView)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    init(delegate: WeatherListViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUpView()
        layoutView()
        setNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpView() {
        self.backgroundColor = .systemBackground
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.refreshControl = refreshControl
        
        delegate?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func layoutView() {
        
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(forName: .init(WeatherJSON.changeWeaterJsonKey), 
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension WeatherListView {
    @objc private func refresh() {
        delegate?.refresh()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @objc private func changeTempUnit() {
        let title = delegate?.changeTempUnit()
        delegate?.navigationItem.rightBarButtonItem?.title = title
        self.tableView.reloadData()
    }
}
