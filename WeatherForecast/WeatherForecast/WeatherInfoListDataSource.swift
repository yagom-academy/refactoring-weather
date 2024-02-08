//
//  WeatherInfoListDataSource.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/6/24.
//

import UIKit

final class WeatherInfoListDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var weatherInfo: WeatherInfoProtocol?
    private var imageManager: ImageManagerProtocol
    private var tempUnit: TemperatureUnit?
    
    // MARK: - Init
    init(weatherInfo: WeatherInfoProtocol?, imageManager: ImageManagerProtocol) {
        self.weatherInfo = weatherInfo
        self.imageManager = imageManager
        self.tempUnit = weatherInfo?.temperatureUnit
    }
    
    // MARK: - Methods
    func updateWeatherData(with data: WeatherInfoProtocol?) {
        self.weatherInfo = data
    }
    
    // MARK: - TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherInfo?.weatherForecastInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        guard let weatherForecastInfo = weatherInfo?.fetchWeatherForecastItem(at: indexPath.item) else {
            return cell
        }
        
        DispatchQueue.main.async {
            cell.updateCellUI(with: weatherForecastInfo,
                              fetchImage: self.imageManager.fetchImage)
        }
        
        return cell
    }
    
    
}
