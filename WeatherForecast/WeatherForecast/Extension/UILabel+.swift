//
//  UILabel+.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/20/24.
//

import UIKit

extension UILabel {
    convenience init(textColor: UIColor, font: UIFont, numberOfLines: Int) {
        self.init(frame: .zero)
        
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
