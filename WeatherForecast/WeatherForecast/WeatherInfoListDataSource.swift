//
//  WeatherInfoListDataSource.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/6/24.
//

import UIKit

final class WeatherInfoListDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var weatherData: WeatherData?
    private var tempUnit: TemperatureUnit
    private var imageManager: ImageManagerProtocol
    
    // MARK: - Init
    init(weatherData: WeatherData?, tempUnit: TemperatureUnit, imageManager: ImageManagerProtocol) {
        self.weatherData = weatherData
        self.tempUnit = tempUnit
        self.imageManager = imageManager
    }
    
    // MARK: - Methods
    func updateWeatherData(with data: WeatherData) {
        self.weatherData = data
    }
    
    // MARK: - TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        guard let weatherForecastInfo = weatherData?.weatherForecast,
                indexPath.row < weatherForecastInfo.count else {
            return cell
        }
        
        DispatchQueue.main.async {
            cell.updateCellUI(with: weatherForecastInfo[indexPath.row],
                              tempUnit: self.tempUnit,
                              fetchImage: self.imageManager.fetchImage)
        }
        
        return cell
    }
    
    
}
