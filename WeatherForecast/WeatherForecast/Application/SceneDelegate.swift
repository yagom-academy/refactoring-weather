//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let weatherFetcherService: WeatherFetcherServiceable = WeatherFetcherService()
    
    let imagefetcherService: ImageFetcherServiceable = ImageFetcherService()
    let weatherImageCacheService: WeatherImageCacheServiceable = WeatherImageCacheService(
        service: imagefetcherService
    )
    
    let weatherViewController: UIViewController = WeatherListViewController(
        weatherFetcherService: weatherFetcherService,
        weatherImageCacheService: weatherImageCacheService
    )
    let navigationController: UINavigationController = .init(rootViewController: weatherViewController)
    
    window = .init(windowScene: scene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
