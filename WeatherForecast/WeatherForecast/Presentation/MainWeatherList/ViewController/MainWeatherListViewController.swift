//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainWeatherListViewController: UIViewController {
    // MARK: - Properties
    struct Dependency {
        let mainWeatherListViewFactory: (MainWeatherListView.Dependency) -> MainWeatherListView
        let weatherJsonService: JsonService
        let imageService: NetworkService
        let tempUnitManager: TempUnitManagerService
    }
    
    private let dependency: Dependency
    
    // MARK: - UI
    private var mainWeatherListView: MainWeatherListView!
    
    // MARK: - Init
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        layoutView()
    }
    
    // MARK: - Layout
    private func layoutView() {
        view.addSubview(mainWeatherListView)
        mainWeatherListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainWeatherListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainWeatherListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainWeatherListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainWeatherListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension MainWeatherListViewController: MainWeatherListViewDelete {
    func showWeatherDetailInfo(detailVC: WeatherDetailViewController) {
        navigationController?.show(detailVC, sender: self)
    }
    
    func changeNavigationTitle(title: String?) {
        navigationItem.title = title
    }
    
    @objc private func changeTempUnit() {
        dependency.tempUnitManager.update()
        navigationItem.rightBarButtonItem?.title = dependency.tempUnitManager.tempUnit
            .strOpposite
        
        mainWeatherListView.refresh()
    }
    
    private func initialSetUp() {
        mainWeatherListView = (createMainWeatherListView() as! MainWeatherListView)
        
        view.backgroundColor = .systemBackground
        mainWeatherListView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: dependency.tempUnitManager.tempUnit.strOpposite,
            image: nil,
            target: self,
            action: #selector(changeTempUnit)
        )
    }
}

extension MainWeatherListViewController {
    private func createMainWeatherListView() -> UIView {
        let mainWeatherListViewDependency = createMainWeatherListViewDependency()
        
        let mainWeatherListView = dependency.mainWeatherListViewFactory(mainWeatherListViewDependency)
        
        return mainWeatherListView
    }
    
    private func createMainWeatherListViewDependency() -> MainWeatherListView.Dependency {
        let weatherDetailViewControllerFactory = { dependency in
          WeatherDetailViewController(dependency: dependency)
        }
        
        let weatherDetailViewFactory = { dependency in
            WeatherDetailView(dependency: dependency)
        }
        
        let mainWeatherListViewDependency: MainWeatherListView.Dependency = .init(
            weatherDetailViewControllerFactory: weatherDetailViewControllerFactory,
            weatherDetailViewFactory: weatherDetailViewFactory,
            weatherJsonService: dependency.weatherJsonService,
            imageService: dependency.imageService,
            tempUnitManager: dependency.tempUnitManager
        )
      
      return mainWeatherListViewDependency
    }
}
