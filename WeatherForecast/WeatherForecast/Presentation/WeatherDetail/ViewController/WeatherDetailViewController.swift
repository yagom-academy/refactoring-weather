//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    // MARK: - Properties
    struct Dependency {
        let weatherDetailViewFactory: (WeatherDetailView.Dependency) -> WeatherDetailView
        let weatherDetailInfo: WeatherDetailInfo
        let imageService: NetworkService
    }
    
    private let dependency: Dependency
        
    // MARK: - Init
    init(
        dependency: Dependency
    ) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = createWeatherDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        navigationItem.title = dependency.weatherDetailInfo.date
    }
}

extension WeatherDetailViewController {
    private func createWeatherDetailView() -> UIView {
        let weatherDetailViewDependency = createWeatherDetailViewDependency()
        
        let weatherDetailView = dependency.weatherDetailViewFactory(weatherDetailViewDependency)
        
        return weatherDetailView
    }
    
    private func createWeatherDetailViewDependency() -> WeatherDetailView.Dependency {
        let weatherDetailViewDependency: WeatherDetailView.Dependency = .init(
            imageService: dependency.imageService,
            weatherDetailInfo: dependency.weatherDetailInfo
        )
        
        return weatherDetailViewDependency
    }
}
