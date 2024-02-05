//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene: UIWindowScene = (scene as? UIWindowScene) else { return }
        
        let weatherViewController = WeatherFactory.createWeatherViewController()
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: weatherViewController)
        
        let window: UIWindow = UIWindow(windowScene: scene)
        window.backgroundColor = .systemBackground
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

class WeatherFactory {
    static func createWeatherViewController() -> WeatherViewController {
        let viewModel = WeatherViewModel()
        let temperatureConverter = TemperatureConverter()
        let refreshControl = UIRefreshControl()
        
        return WeatherViewController(viewModel: viewModel,
                                     temperatureConverter: temperatureConverter,
                                     refreshControl: refreshControl)
    }
}
