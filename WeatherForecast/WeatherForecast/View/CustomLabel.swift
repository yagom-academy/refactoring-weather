//
//  CustomLabel.swift
//  WeatherForecast
//
//  Created by 구 민영 on 3/20/24.
//

import UIKit

final class DetailViewCustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        styleSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleSetup() {
        self.textColor = .black
        self.backgroundColor = .clear
        self.font = .preferredFont(forTextStyle: .body)
        self.numberOfLines = 1
        self.textAlignment = .center
    }
}
