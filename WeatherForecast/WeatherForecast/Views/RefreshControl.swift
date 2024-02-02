//
//  RefreshControl.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

protocol RefreshControlDelegate: AnyObject {
  func refresh()
}

final class RefreshControl: UIRefreshControl {
  
  private weak var delegate: RefreshControlDelegate?
  
  init(_ delegate: RefreshControlDelegate) {
    self.delegate = delegate
    super.init()
    addTarget(
      self,
      action: #selector(refresh),
      for: .valueChanged
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension RefreshControl {
  @MainActor
  @objc private func refresh() {
    if isRefreshing {
      endRefreshing()
    }
    delegate?.refresh()
  }
}
