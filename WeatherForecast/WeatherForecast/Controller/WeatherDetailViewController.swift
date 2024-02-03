//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
  
  struct Dependency {
    let weatherDetailModel: WeatherDetailModel
    let imageProvider: ImageProviderService
  }
  
  private let dependency: Dependency
  
  private let weatherDetailView = WeatherDetailView()

  init(dependency: Dependency) {
    self.dependency = dependency
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
  
  private func initialSetUp() {
    view.backgroundColor = .white
        
    navigationItem.title = dependency.weatherDetailModel.dt
        
    view.addSubview(weatherDetailView)
    weatherDetailView.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      weatherDetailView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      weatherDetailView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      weatherDetailView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                             constant: 16),
      weatherDetailView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                              constant: -16)
    ])
    
    weatherDetailView.update(dependency.weatherDetailModel)
  }
}
