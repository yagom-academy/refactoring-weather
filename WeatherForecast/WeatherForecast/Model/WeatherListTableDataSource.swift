//
//  WeatherListDataSource.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/19/24.
//

import UIKit

final class WeatherListTableDataSource: NSObject, UITableViewDataSource {
    var weathers: [WeatherForecastInfo]?
    
    convenience override init() {
        self.init(weathers: nil)
    }
    
    init(weathers: [WeatherForecastInfo]?) {
        self.weathers = weathers
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weathers?[indexPath.row] else {
            return cell
        }
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(Shared.tempUnit.applyTempUnit(temp: weatherForecastInfo.main.temp))\(Shared.tempUnit.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = DateFormatter.KRFullFormat.string(from: date)
                
        let iconName: String = weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        ImageChacher.shared.load(urlString: urlString, completion: { image in
            if indexPath == tableView.indexPath(for: cell) {
                cell.weatherIcon.image = image
            }
        })
        
        return cell
    }
}
