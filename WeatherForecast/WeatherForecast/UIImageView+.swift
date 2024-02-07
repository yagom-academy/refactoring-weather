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
        if let imageFromMemory = imageLoader.getImage(from: .memory, forKey: urlString) {
            self.image = imageFromMemory
            return
        }
        
        if let imageFromDisk = imageLoader.getImage(from: .disk, forKey: urlString) {
            self.image = imageFromDisk
            return
        }
        
        Task {
            guard let image = await imageLoader.getImageFromDownload(with: urlString)
            else { return }
            
            await MainActor.run {
                self.image = image
            }
        }
    }
}
