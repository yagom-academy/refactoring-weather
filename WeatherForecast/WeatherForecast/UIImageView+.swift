//
//  UIImageView+.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/7/24.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String,
                  imageLoader: ImageLoadable = ImageLoader()
    ) {
        Task {
            guard let image = await imageLoader.loadImage(with: urlString, from: .all)
            else { return }
            
            await MainActor.run {
                self.image = image
            }
        }
    }
}
