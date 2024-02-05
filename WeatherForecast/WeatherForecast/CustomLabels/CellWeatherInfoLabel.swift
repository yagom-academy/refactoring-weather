//
//  CustomLabel.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

final class CellWeatherInfoLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        textColor = UIColor.black
        font = .preferredFont(forTextStyle: .body)
        numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
