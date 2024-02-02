//
//  WeatherTableView.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

protocol UITableViewDelegateWithRefresh: UITableViewDelegate {
  func tableView(_ tableView: UITableView, refresh: Void)
}

final class WeatherTableView: UITableView {
  private let isRefreshing: Bool
  private weak var refreshDelegate: UITableViewDelegateWithRefresh?
  
  init(
    delegate: UITableViewDelegateWithRefresh,
    dataSource: UITableViewDataSource,
    style: UITableView.Style = .plain,
    isRefreshing: Bool = true
  ) {
    self.isRefreshing = isRefreshing
    super.init(
      frame: .zero,
      style: style
    )
    self.refreshDelegate = delegate
    self.dataSource = dataSource
    register()
    setup()
  }
  
  @MainActor
  override func reloadData() {
    super.reloadData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WeatherTableView {
  private func register() {
    register(
      WeatherTableViewCell.self,
      forCellReuseIdentifier: "WeatherCell"
    )
  }
  
  private func setup() {
    if isRefreshing {
      let refreshControl = RefreshControl(self)
      self.refreshControl = refreshControl
    }
  }
}

extension WeatherTableView: RefreshControlDelegate {
  func refresh() {
    refreshDelegate?.tableView(
      self, 
      refresh: ()
    )
  }
}
