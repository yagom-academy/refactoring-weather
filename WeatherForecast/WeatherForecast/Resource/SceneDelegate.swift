//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let weatherService: WeatherJSONService = WeatherJSONService()
        let imageService: WeatherImageService = WeatherImageService()
        let tempUnit = TempUnit.fahrenheit
        
        let viewController = WeatherViewController(tempUnit: tempUnit, 
                                                   weatherService: weatherService,
                                                   imageService: imageService)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

