//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
  
  struct Dependency {
    let weatherDetailViewControllerModel: WeatherDetailViewControllerModel
    let imageProvider: ImageProviderService
  }
  
  private let dependency: Dependency
  
  private let iconImageView: UIImageView = UIImageView()
  private let weatherGroupLabel: UILabel = UILabel()
  private let weatherDescriptionLabel: UILabel = UILabel()
  private let weatherConditionView = WeatherConditionView()
  private let spacingView: UIView = UIView()

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
        
    navigationItem.title = dependency.weatherDetailViewControllerModel.dt
    
    spacingView.backgroundColor = .clear
    spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
    
    let mainStackView: UIStackView = .init(arrangedSubviews: [
      iconImageView,
      weatherGroupLabel,
      weatherDescriptionLabel,
      weatherConditionView,
      spacingView
    ])
    
    mainStackView.arrangedSubviews.forEach { subview in
      guard let subview: UILabel = subview as? UILabel else { return }
      subview.textColor = .black
      subview.backgroundColor = .clear
      subview.numberOfLines = 1
      subview.textAlignment = .center
      subview.font = .preferredFont(forTextStyle: .body)
    }
    
    weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
    weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
    
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = 8
    view.addSubview(mainStackView)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                             constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                              constant: -16),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
      iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                           multiplier: 0.3)
    ])
    
    weatherGroupLabel.text = dependency.weatherDetailViewControllerModel.weatherGroup
    weatherDescriptionLabel.text = dependency.weatherDetailViewControllerModel.weatherDescription
    
    weatherConditionView.update(dependency.weatherDetailViewControllerModel.weatherConditions)
    
    Task {
      let image = await dependency.imageProvider.image(url: dependency.weatherDetailViewControllerModel.imageURL)
      iconImageView.image = image
    }
  }
}
