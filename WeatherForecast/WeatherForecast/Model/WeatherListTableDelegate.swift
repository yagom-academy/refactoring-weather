//
//  WeatherListTableDelegate.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/19/24.
//

import UIKit

class WeatherListTableDelegate: NSObject, UITableViewDelegate {
    let baseVC: UIViewController
    var weathers: [WeatherForecastInfo]?
    var city: City?
    
    convenience init(baseVC: UIViewController) {
        self.init(baseVC: baseVC, weathers: nil, city: nil)
    }
    
    init(baseVC: UIViewController, weathers: [WeatherForecastInfo]?, city: City?) {
        self.baseVC = baseVC
        self.weathers = weathers
        self.city = city
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let weathers,
              let city else {return}
        
        let weatherForecastInfo = weathers[indexPath.row]
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(info: DetailInfo(weatherForecastInfo: weatherForecastInfo, cityInfo: city))
        baseVC.navigationController?.show(detailViewController, sender: self)
    }
}
