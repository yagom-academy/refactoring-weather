//
//  WeatherListViewModel.swift
//  WeatherForecast
//
//  Created by 박상욱 on 2/3/24.
//

import Foundation
import Combine


protocol WeatherListViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}


final class WeatherListViewModel {
    var cancellable = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    private let weatherService: WeatherService
    
    private(set) var tempUnit: TempUnit = .metric
    private(set) var weatherInfo: WeatherList?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
}


extension WeatherListViewModel {
    enum Input {
        case viewWillAppear
        case setRefreshWithTableView
        case updateTempUnit(TempUnit)
    }
    
    enum Output {
        case tempUnit
        case fetchWeatherList
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                
                switch event {
                case .setRefreshWithTableView, .viewWillAppear:
                    let info = weatherService.fetchWeatherService(tempUnit: tempUnit)
                    weatherInfo = info
                    output.send(.fetchWeatherList)
                    
                case .updateTempUnit(let unit):
                    tempUnit = unit
                    
                    let info = weatherService.fetchWeatherService(tempUnit: tempUnit)
                    weatherInfo = info
                    
                    output.send(.tempUnit)
                    output.send(.fetchWeatherList)
                }
            }
            .store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
}
