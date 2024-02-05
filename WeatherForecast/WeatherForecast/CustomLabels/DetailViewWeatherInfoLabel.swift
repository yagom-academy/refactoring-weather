//
//  CustomDetailLabel.swift
//  WeatherForecast
//
//  Created by kodirbek on 2/1/24.
//

import UIKit

final class DetailViewWeatherInfoLabel: UILabel {

    init(with uiFont: UIFont = .preferredFont(forTextStyle: .body)) {
        super.init(frame: .zero)
        textColor = .black
        backgroundColor = .clear
        numberOfLines = 1
        textAlignment = .center
        font = uiFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
