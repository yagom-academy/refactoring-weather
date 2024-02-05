//
//  Extension+UITableView.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/5/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: WeatherTableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellId, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.cellId)")
        }
        return cell
    }
}
