//
//  WeatherListView.swift
//  WeatherForecast
//
//  Created by Daegeon Choi on 2024/02/02.
//

import Foundation
import UIKit

protocol WeatherListViewDelegate: UITableViewDelegate, UITableViewDataSource, UIViewController {
    func refresh()
    func changeTempUnit() -> String
    var navigationItem: UINavigationItem { get }
}

final class WeatherListView: UIView {
    
    private var delegate: WeatherListViewDelegate
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    init(delegate: WeatherListViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUpView()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.refreshControl = refreshControl
        
        delegate.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
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
}

extension WeatherListView {
    @objc private func refresh() {
        delegate.refresh()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func changeTempUnit() {
        let title = delegate.changeTempUnit()
        delegate.navigationItem.rightBarButtonItem?.title = title
        self.tableView.reloadData()
    }
}
