//
//  MainView.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/4/24.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func refreshTableView()
}

final class MainView: UIView {
    
    private var delegate: MainViewDelegate!
    
    let tableView: UITableView = .init(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    init(delegate: MainViewDelegate,
         tableViewDelegate: UITableViewDelegate,
         tableViewDataSource: UITableViewDataSource
    ) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDataSource
        
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        backgroundColor = .white
        
        layTable()
        initialTableViewSetUp()
    }
    
    private func layTable() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func initialTableViewSetUp() {
        refreshControl.addTarget(self,
                                 action: #selector(refreshStart),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
    }
        
    @objc private func refreshStart() {
        delegate.refreshTableView()
    }
    
    func refreshEnd() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}


