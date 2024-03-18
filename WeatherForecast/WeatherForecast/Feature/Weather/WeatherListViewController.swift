//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

final class WeatherListViewController: UIViewController {
    
    private var weatherForecast: [WeatherForecastInfo]?
    private var city: City?
    private var tempUnit: TempUnit = .metric
    
    private let weatherRepository: WeatherRepository
    private let imageFetcher: ImageFetcher
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        weatherRepository: WeatherRepository,
        imageFetcher: ImageFetcher
    ) {
        self.weatherRepository = weatherRepository
        self.imageFetcher = imageFetcher
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherListViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
        case .metric:
            tempUnit = .imperial
        }
        navigationItem.rightBarButtonItem?.title = tempUnit.krString
        refresh()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: TempUnit.imperial.krString, image: nil, target: self, action: #selector(changeTempUnit))
        view = WeatherListView(delegate: self)
        
        refresh()
    }
}

extension WeatherListViewController: WeatherListViewDelegate {
    func weatherSelected(_ weather: WeatherForecastInfo) {
        guard let city: City else { return }
        
        let detailViewController: WeatherDetailViewController = .init(
            weatherForecastInfo: weather,
            cityInfo: city,
            tempUnit: tempUnit,
            imageFetcher: imageFetcher
        )
        navigationController?.show(detailViewController, sender: self)
    }
    
    func refresh() {
        weatherRepository.fetchWeather()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    // handle error
                    print(error)
                }
            } receiveValue: { [weak self] fetchResult in
                guard let self, let view = view as? WeatherListView else { return }
                
                self.weatherForecast = fetchResult.weatherForecast
                self.city = fetchResult.city
                view.updateUI()
            }.store(in: &cancellables)
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let weather: WeatherForecastInfo = weatherForecast?[indexPath.row] else { return }
        weatherSelected(weather)
    }
}

extension WeatherListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherForecast: [WeatherForecastInfo] else { return 0 }
        
        return weatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.ReuseIdentifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo: WeatherForecastInfo = weatherForecast?[indexPath.row] else {
            return cell
        }
        
        cell.setImageFetcher(imageFetcher)
        cell.updateUI(
            weatherMain: weatherForecastInfo.mainString,
            weatherDescription: weatherForecastInfo.description,
            temperature: tempUnit.convert(weatherForecastInfo.temperature),
            date: weatherForecastInfo.dateString,
            icon: weatherForecastInfo.iconUrlString
        )
        
        return cell
    }
}
