//
//  WeatherListDataSource.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/19/24.
//

import UIKit

class WeatherListTableDataSource: NSObject, UITableViewDataSource {
    var weathers: [WeatherForecastInfo]
    var tempUnit: TempUnit
    
    init(weathers: [WeatherForecastInfo], tempUnit: TempUnit) {
        self.weathers = weathers
        self.tempUnit = tempUnit
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell else {
            return cell
        }
        
        let weatherForecastInfo = weathers[indexPath.row]
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = Date.string(from: date, format: "yyyy-MM-dd(EEEEE) a HH:mm")
                
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
