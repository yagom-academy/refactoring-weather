//
//  CustomLabel.swift
//  WeatherForecast
//
//  Created by kodirbek on 1/31/24.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.black
        font = .preferredFont(forTextStyle: .body)
        numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
