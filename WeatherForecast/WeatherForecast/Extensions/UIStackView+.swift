//
//  UIStackView+.swift
//  WeatherForecast
//
//  Created by 홍은표 on 3/12/24.
//

import UIKit

extension UIStackView {
  convenience init(
      arrangedSubviews views: [UIView],
      alignment: UIStackView.Alignment,
      axis: NSLayoutConstraint.Axis,
      distribution: UIStackView.Distribution = .fill,
      spacing: CGFloat
  ) {
    self.init(arrangedSubviews: views)
    self.alignment = alignment
    self.axis = axis
    self.distribution = distribution
    self.spacing = spacing
  }
}
