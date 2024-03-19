//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let weatherFetcherService: WeatherFetcherServiceable = WeatherFetcherService()
    
    let httpSessionService: HTTPSessionServiceable = HTTPSessionService()
    let weatherImageCacheService: WeatherImageCacheServiceable = WeatherImageCacheService(
        service: httpSessionService
    )
    
    let weatherUseCase: WeatherUseCase = WeatherUseCaseImpl(
        weatherFetcherService: weatherFetcherService,
        weatherImageCacheService: weatherImageCacheService
    )
    
    let weatherViewController: UIViewController = WeatherListViewController(weatherUseCase: weatherUseCase)
    let navigationController: UINavigationController = .init(rootViewController: weatherViewController)
    
    window = .init(windowScene: scene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
