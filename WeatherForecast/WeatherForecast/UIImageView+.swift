//
//  UIImageView+.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/7/24.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String, 
                  memory memoryCacheManager: ImageCacheable = MemoryCacheManager.shared,
                  disk diskCacheManager: ImageCacheable? = DiskCacheManager(),
                  with networkManager: NetworkManagerDelegate?
    ) {
        if let imageFromMemory = memoryCacheManager.getImage(forKey: urlString) {
            self.image = imageFromMemory
            return
        }
        
        if let imageFromDisk = diskCacheManager?.getImage(forKey: urlString) {
            self.image = imageFromDisk
            return
        }
        
        Task {[weak self] in
            guard let image = await networkManager?.getIconImage(with: urlString) else { return
            }
            
            memoryCacheManager.setImage(image, forKey: urlString)
            diskCacheManager?.setImage(image, forKey: urlString)
            
            await MainActor.run {
                self?.image = image
            }
        }
    }
}
