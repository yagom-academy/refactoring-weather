//
//  Extension+UILabel.swift
//  WeatherForecast
//
//  Created by 김창규 on 2/1/24.
//

import UIKit

extension UILabel {
    func makeWeatherDetailLabel(labelColor: UIColor = .black,
                                backgroundColor: UIColor = .clear,
                                numberOfLines: Int = 1,
                                textAlignment: NSTextAlignment = .center,
                                font: UIFont = .preferredFont(forTextStyle: .body)) {
        self.textColor = labelColor
        self.backgroundColor = backgroundColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.font = font
    }
}
