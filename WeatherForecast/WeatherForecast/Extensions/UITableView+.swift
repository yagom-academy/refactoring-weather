//
//  UITableView+.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/17/24.
//

import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_ cellClass: T.Type) where T: CellIdentifiable {
    self.register(cellClass, forCellReuseIdentifier: T.identifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(
    for indexPath: IndexPath
  ) -> T where T: CellIdentifiable {
    guard let cell = dequeueReusableCell(
      withIdentifier: T.identifier,
      for: indexPath
    ) as? T else {
      fatalError("\(T.identifier) - onError dequeueReusableCell")
    }
    
    return cell
  }
}
