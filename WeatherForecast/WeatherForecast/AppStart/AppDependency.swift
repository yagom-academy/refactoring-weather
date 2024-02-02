//
//  AppDependency.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

import UIKit

struct AppDependency {
  let window: UIWindow
}

extension AppDependency {
  static func resolve(_ scene: UIWindowScene) -> AppDependency {
    let window: UIWindow = UIWindow(windowScene: scene)
    window.makeKeyAndVisible()
    let dataAssetProvider: DataAssetProviderService = DataAssetProvider.shared
    let imageProvider: ImageProviderService = ImageProvider.shared
    let defaultDateFormatter: DateFormatterContextService = DateFormatterContext(strategy: DefaultDateFormatterStrategy())
    let sunsetDateFormatter: DateFormatterContextService = DateFormatterContext(strategy: SunsetDateFormatterStrategy())

      
    let weatherViewControllerFactory = { dependency in
      WeatherDetailViewController(dependency: dependency)
    }
    
    let viewController = ViewController(
      dependency: .init(
        weatherDetailViewControllerFactory: weatherViewControllerFactory,
        defaultDateFormatter: defaultDateFormatter,
        sunsetDateFormatter: sunsetDateFormatter,
        dataAssetProvider: dataAssetProvider,
        imageProvider: imageProvider
      )
    )
    
    let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
    
    window.backgroundColor = .white
    window.rootViewController = navigationController
    
    return AppDependency(
      window: window
    )
  }
}
