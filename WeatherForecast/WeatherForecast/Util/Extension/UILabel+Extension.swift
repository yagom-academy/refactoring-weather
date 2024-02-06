//
//  UILabel+Extension.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/05.
//

import UIKit

extension UILabel {
    func makeLabel(textColor: UIColor = .black,
                   numberOfLines: Int = 1,
                   textAlignment: NSTextAlignment = .center,
                   font: UIFont = .preferredFont(forTextStyle: .body)) {
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.font = font
    }
}
