//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainWeatherListViewController: UIViewController {
    // MARK: - Properties
    private var weatherJSON: WeatherJSON?
    private var tempUnit: TempUnit = .metric

    // MARK: - View
    private let mainWeatherListView: MainWeatherListView!
    
    init(mainWeatherListView: MainWeatherListView) {
        self.mainWeatherListView = mainWeatherListView
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
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "화씨"
        }
        
        mainWeatherListView.refresh()
    }
    
    private func initialSetUp() {
        view.backgroundColor = .systemBackground
        mainWeatherListView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
    }
}

